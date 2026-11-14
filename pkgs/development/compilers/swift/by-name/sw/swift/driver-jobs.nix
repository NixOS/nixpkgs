{
  lib,
  stdenv,
  swift,
  llvmPackages_upstream,
}:

let
  clang = llvmPackages_upstream.clang;
in
stdenv.mkDerivation {
  name = "swift-native-driver-jobs-test";
  dontUnpack = true;
  nativeBuildInputs = [
    swift
    clang
  ];
  buildPhase = ''
    runHook preBuild

    # The native importer reads header support files from the adjacent Clang.
    # It must find the selected C headers without a parent shell wrapper.
    cat > system.swift <<'EOF'
    import ${if stdenv.hostPlatform.isDarwin then "Darwin" else "Glibc"}
    let pid = getpid()
    EOF
    swiftc -typecheck system.swift

    mkdir library
    echo 'int wrapper_probe(void) { return 42; }' > probe.c
    clang -shared -fPIC probe.c -o library/libwrapper_probe${stdenv.hostPlatform.extensions.sharedLibrary}
    cat > use.swift <<'EOF'
    @_silgen_name("wrapper_probe") func probe() -> Int32
    print(probe())
    EOF

    savedLdflags="''${NIX_LDFLAGS:-}"
    for response in 0 1; do
      NIX_CC_USE_RESPONSE_FILE=$response \
        NIX_LDFLAGS="$savedLdflags -L$PWD/library -lwrapper_probe -rpath $PWD/library" \
        swiftc use.swift -o "use-$response"
      test "$(./use-$response)" = 42
    done

    # Interpretation uses the native driver's explicit library-path interface.
    swift -L "$PWD/library" -lwrapper_probe use.swift > interpreted
    test "$(cat interpreted)" = 42

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      # An empty LD_LIBRARY_PATH entry names the current directory, even when
      # selected toolchain paths follow it. Preserve the caller's empty -L.
      echo 'int wrapper_probe(void) { return 43; }' > local-probe.c
      clang -shared -fPIC local-probe.c -o libwrapper_probe.so
      swift -L "" -L "$PWD/library" -lwrapper_probe use.swift > interpreted-local
      test "$(cat interpreted-local)" = 43
    ''}

    # The actual compiler job must use the final C++ interoperability mode,
    # including the selected C++ link channel rather than only autolink flags.
    cat > cxx.swift <<'EOF'
    import CxxStdlib
    @_silgen_name("wrapper_probe") func probe() -> Int32
    print(String(std.string("Hello, world!")))
    print(probe())
    EOF
    NIX_CXXSTDLIB_LINK="''${NIX_CXXSTDLIB_LINK:-} -L$PWD/library -lwrapper_probe -Wl,-rpath,$PWD/library" \
      swiftc -cxx-interoperability-mode=off -cxx-interoperability-mode=default cxx.swift -o cxx
    test "$(./cxx)" = "$(printf 'Hello, world!\n42')"
    echo 'print(42)' > plain.swift
    NIX_CXXSTDLIB_LINK=-lnot_a_real_library \
      swiftc -cxx-interoperability-mode=default -cxx-interoperability-mode=off plain.swift -o plain
    test "$(./plain)" = 42

    # Neither a compile job nor an archive invokes a linker.
    NIX_LDFLAGS="$savedLdflags -lnot_a_real_library" swiftc -c use.swift -o use.o
    echo '@_cdecl("swift_answer") public func answer() -> Int32 { 42 }' > archive.swift
    NIX_LDFLAGS="$savedLdflags -lnot_a_real_library" \
      swiftc -emit-library -static archive.swift -o libArchive.a
    test -s libArchive.a

    runHook postBuild
  '';

  installPhase = ''
    mkdir "$out"
    cp interpreted "$out/"
  '';

  meta.platforms = swift.meta.platforms;
}
