{ stdenv
, fetch
, fetchpatch
, cmake
, python
, libffi
, libbfd
, libxml2
, ncurses
, version
, release_version
, zlib
, compiler-rt_src
, debugVersion ? false
, enableManpages ? false
, enableSharedLibraries ? !enableManpages
}:

let
  # Used when creating a versioned symlinks of libLLVM.dylib
  versionSuffixes = with stdenv.lib;
    let parts = splitVersion release_version; in
    imap (i: _: concatStringsSep "." (take i parts)) parts;
in

stdenv.mkDerivation ({
  pname = "llvm";
  inherit version;

  src = fetch "llvm" "0l9bf7kdwhlj0kq1hawpyxhna1062z3h7qcz2y8nfl9dz2qksy6s";

  unpackPhase = ''
    unpackFile $src
    mv llvm-${version}* llvm
    sourceRoot=$PWD/llvm
    unpackFile ${compiler-rt_src}
    mv compiler-rt-* $sourceRoot/projects/compiler-rt
  '';

  outputs = [ "out" ]
    ++ stdenv.lib.optional enableSharedLibraries "lib";

  nativeBuildInputs = [ cmake python ]
    ++ stdenv.lib.optional enableManpages python.pkgs.sphinx;

  buildInputs = [ libxml2 libffi ];

  propagatedBuildInputs = [ ncurses zlib ];

  patches = [
    (fetchpatch {
      name = "0001-Fix-return-type-in-ORC-readMem-client-interface.patch";
      url = "https://bugzilla.redhat.com/attachment.cgi?id=1389687";
      sha256 = "0ga2123aclq3x9w72d0rm0az12m8c1i4r1106vh701hf4cghgbch";
    })
    ./fix-gcc9.patch
    (fetchpatch {
      name = "llvm4-avoid-undefined-behavior-in-unittest.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/D32089-Avoid-undefined-behavior-in-unittest.patch?h=llvm40&id=f459b0bad8aa3b94bc2733d79d176071a32846a6";
      sha256 = "0x5q6a8lk6xg4ns4qh75fxvvmfnifwvyrq17ck85q8c0753i1irf";
      extraPrefix = "";
    })
  ];

  # TSAN requires XPC on Darwin, which we have no public/free source files for. We can depend on the Apple frameworks
  # to get it, but they're unfree. Since LLVM is rather central to the stdenv, we patch out TSAN support so that Hydra
  # can build this. If we didn't do it, basically the entire nixpkgs on Darwin would have an unfree dependency and we'd
  # get no binary cache for the entire platform. If you really find yourself wanting the TSAN, make this controllable by
  # a flag and turn the flag off during the stdenv build.
  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace ./projects/compiler-rt/cmake/config-ix.cmake \
      --replace 'set(COMPILER_RT_HAS_TSAN TRUE)' 'set(COMPILER_RT_HAS_TSAN FALSE)'

    substituteInPlace cmake/modules/AddLLVM.cmake \
      --replace 'set(_install_name_dir INSTALL_NAME_DIR "@rpath")' "set(_install_name_dir)" \
      --replace 'set(_install_rpath "@loader_path/../lib" ''${extra_libdir})' ""
  ''
  # Patch llvm-config to return correct library path based on --link-{shared,static}.
  + stdenv.lib.optionalString (enableSharedLibraries) ''
    substitute '${./llvm-outputs.patch}' ./llvm-outputs.patch --subst-var lib
    patch -p1 < ./llvm-outputs.patch
  ''
  + ''
    (
      cd projects/compiler-rt
      patch -p1 < ${
        fetchpatch {
          name = "sigaltstack.patch"; # for glibc-2.26
          url = https://github.com/llvm-mirror/compiler-rt/commit/8a5e425a68d.diff;
          sha256 = "0h4y5vl74qaa7dl54b1fcyqalvlpd8zban2d1jxfkxpzyi7m8ifi";
        }
      }
      substituteInPlace lib/esan/esan_sideline_linux.cpp \
        --replace 'struct sigaltstack' 'stack_t'
    )
  '' + # Fix extra space printed in commandline help sometimes, "- help"
  ''
    patch -p1 -i ${./cmdline-help.patch}
  '' + stdenv.lib.optionalString stdenv.isAarch64 ''
    patch -p0 < ${../aarch64.patch}
  '' + stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    patch -p1 -i ${../TLI-musl.patch}
    patch -p1 -i ${../dynamiclibrary-musl.patch}
    patch -p1 -i ${./sanitizers-nongnu.patch} -d projects/compiler-rt
  '';

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=${if debugVersion then "Debug" else "Release"}"
    "-DLLVM_INSTALL_UTILS=ON"  # Needed by rustc
    "-DLLVM_BUILD_TESTS=ON"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_ENABLE_RTTI=ON"
    "-DCOMPILER_RT_INCLUDE_TESTS=OFF" # FIXME: requires clang source code

    "-DLLVM_HOST_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_DEFAULT_TARGET_TRIPLE=${stdenv.hostPlatform.config}"
    "-DTARGET_TRIPLE=${stdenv.hostPlatform.config}"
  ]
  ++ stdenv.lib.optional enableSharedLibraries
    "-DLLVM_LINK_LLVM_DYLIB=ON"
  ++ stdenv.lib.optionals enableManpages [
    "-DLLVM_BUILD_DOCS=ON"
    "-DLLVM_ENABLE_SPHINX=ON"
    "-DSPHINX_OUTPUT_MAN=ON"
    "-DSPHINX_OUTPUT_HTML=OFF"
    "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
  ]
  ++ stdenv.lib.optional (!isDarwin)
    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
  ++ stdenv.lib.optionals (isDarwin) [
    "-DLLVM_ENABLE_LIBCXX=ON"
    "-DCAN_TARGET_i386=false"
  ];

  postBuild = ''
    rm -fR $out
  '';

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/lib
  '';

  postInstall = stdenv.lib.optionalString enableSharedLibraries ''
    moveToOutput "lib/libLLVM-*" "$lib"
    moveToOutput "lib/libLLVM${stdenv.hostPlatform.extensions.sharedLibrary}" "$lib"
    substituteInPlace "$out/lib/cmake/llvm/LLVMExports-${if debugVersion then "debug" else "release"}.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/libLLVM-" "$lib/lib/libLLVM-"
  ''
  + stdenv.lib.optionalString (stdenv.isDarwin && enableSharedLibraries) ''
    substituteInPlace "$out/lib/cmake/llvm/LLVMExports-${if debugVersion then "debug" else "release"}.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/libLLVM.dylib" "$lib/lib/libLLVM.dylib"
    ${stdenv.lib.concatMapStringsSep "\n" (v: ''
      ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${v}.dylib
    '') versionSuffixes}
  '';

  doCheck = stdenv.isLinux && (!stdenv.isi686);

  checkTarget = "check-all";

  enableParallelBuilding = true;

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    maintainers = with stdenv.lib.maintainers; [ lovek323 raskin dtzWill ];
    platforms   = stdenv.lib.platforms.all;
  };
} // stdenv.lib.optionalAttrs enableManpages {
  pname = "llvm-manpages";

  buildPhase = ''
    make docs-llvm-man
  '';

  propagatedBuildInputs = [ ];

  installPhase = ''
    make -C docs install
  '';

  outputs = [ "out" ];

  doCheck = false;

  meta.description = "man pages for LLVM ${version}";
})
