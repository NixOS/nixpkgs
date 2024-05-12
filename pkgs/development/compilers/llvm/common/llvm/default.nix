{ lib
, stdenv
, llvm_meta
, pkgsBuildBuild
, pollyPatches ? []
, patches ? []
, polly_src ? null
, src ? null
, monorepoSrc ? null
, runCommand
, cmake
, darwin
, ninja
, python3
, python3Packages
, libffi
  # TODO: Can this memory corruption bug still occur?
  # <https://github.com/llvm/llvm-project/issues/61350>
, enableGoldPlugin ? libbfd.hasPluginAPI
, libbfd
, libpfm
, libxml2
, ncurses
, version
, release_version
, zlib
, which
, sysctl
, buildLlvmTools
, debugVersion ? false
, doCheck ? !stdenv.isAarch32 && (if lib.versionOlder release_version "15" then stdenv.isLinux else true)
  && (!stdenv.isx86_32 /* TODO: why */) && (!stdenv.hostPlatform.isMusl)
  && !(stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isBigEndian)
  && (stdenv.hostPlatform == stdenv.buildPlatform)
, enableManpages ? false
, enableSharedLibraries ? !stdenv.hostPlatform.isStatic
, enablePFM ? stdenv.isLinux /* PFM only supports Linux */
  # broken for Ampere eMAG 8180 (c2.large.arm on Packet) #56245
  # broken for the armv7l builder
  && !stdenv.hostPlatform.isAarch
, enablePolly ? lib.versionAtLeast release_version "14"
}:

let
  inherit (lib) optional optionals optionalString;

  # Used when creating a version-suffixed symlink of libLLVM.dylib
  shortVersion = with lib;
    concatStringsSep "." (take 1 (splitString "." release_version));

  # Ordinarily we would just the `doCheck` and `checkDeps` functionality
  # `mkDerivation` gives us to manage our test dependencies (instead of breaking
  # out `doCheck` as a package level attribute).
  #
  # Unfortunately `lit` does not forward `$PYTHONPATH` to children processes, in
  # particular the children it uses to do feature detection.
  #
  # This means that python deps we add to `checkDeps` (which the python
  # interpreter is made aware of via `$PYTHONPATH` – populated by the python
  # setup hook) are not picked up by `lit` which causes it to skip tests.
  #
  # Adding `python3.withPackages (ps: [ ... ])` to `checkDeps` also doesn't work
  # because this package is shadowed in `$PATH` by the regular `python3`
  # package.
  #
  # So, we "manually" assemble one python derivation for the package to depend
  # on, taking into account whether checks are enabled or not:
  python = if doCheck then
    # Note that we _explicitly_ ask for a python interpreter for our host
    # platform here; the splicing that would ordinarily take care of this for
    # us does not seem to work once we use `withPackages`.
    let
      checkDeps = ps: with ps; [ psutil ];
    in pkgsBuildBuild.targetPackages.python3.withPackages checkDeps
  else python3;

  pname = "llvm";

  src' = if monorepoSrc != null then
    runCommand "${pname}-src-${version}" {} (''
      mkdir -p "$out"
      cp -r ${monorepoSrc}/cmake "$out"
      cp -r ${monorepoSrc}/${pname} "$out"
      cp -r ${monorepoSrc}/third-party "$out"
    '' + lib.optionalString enablePolly ''
      chmod u+w "$out/${pname}/tools"
      cp -r ${monorepoSrc}/polly "$out/${pname}/tools"
    '') else src;

  patches' = patches ++ lib.optionals enablePolly pollyPatches;
in

stdenv.mkDerivation (rec {
  inherit pname version;

  src = src';
  patches = patches';

  sourceRoot = if lib.versionOlder release_version "13" then null
    else "${src.name}/${pname}";

  outputs = [ "out" "lib" "dev" "python" ];

  nativeBuildInputs = [ cmake ]
    ++ (lib.optional (lib.versionAtLeast release_version "15") ninja)
    ++ [ python ]
    ++ optionals enableManpages [
    # Note: we intentionally use `python3Packages` instead of `python3.pkgs`;
    # splicing does *not* work with the latter. (TODO: fix)
    python3Packages.sphinx
  ] ++ optionals (lib.versionOlder version "18" && enableManpages) [
    python3Packages.recommonmark
  ] ++ optionals (lib.versionAtLeast version "18" && enableManpages) [
    python3Packages.myst-parser
  ];

  buildInputs = [ libxml2 libffi ]
    ++ optional enablePFM libpfm; # exegesis

  propagatedBuildInputs = (lib.optional (lib.versionAtLeast release_version "14" || stdenv.buildPlatform == stdenv.hostPlatform) ncurses)
    ++ [ zlib ];

  postPatch = optionalString stdenv.isDarwin (''
    substituteInPlace cmake/modules/AddLLVM.cmake \
      --replace 'set(_install_name_dir INSTALL_NAME_DIR "@rpath")' "set(_install_name_dir)" \
      --replace 'set(_install_rpath "@loader_path/../''${CMAKE_INSTALL_LIBDIR}''${LLVM_LIBDIR_SUFFIX}" ''${extra_libdir})' ""
  '' + (optionalString (lib.versionAtLeast release_version "15") (''

    # As of LLVM 15, marked as XFAIL on arm64 macOS but lit doesn't seem to pick
    # this up: https://github.com/llvm/llvm-project/blob/c344d97a125b18f8fed0a64aace73c49a870e079/llvm/test/MC/ELF/cfi-version.ll#L7
    rm test/MC/ELF/cfi-version.ll

    # This test tries to call `sw_vers` by absolute path (`/usr/bin/sw_vers`)
    # and thus fails under the sandbox:
  '' + (if lib.versionAtLeast release_version "16" then ''
    substituteInPlace unittests/TargetParser/Host.cpp \
      --replace '/usr/bin/sw_vers' "${(builtins.toString darwin.DarwinTools) + "/bin/sw_vers" }"
  '' else ''
    substituteInPlace unittests/Support/Host.cpp \
      --replace '/usr/bin/sw_vers' "${(builtins.toString darwin.DarwinTools) + "/bin/sw_vers" }"
  '') + optionalString (lib.versionAtLeast release_version "16") ''

    # This test tries to call the intrinsics `@llvm.roundeven.f32` and
    # `@llvm.roundeven.f64` which seem to (incorrectly?) lower to `roundevenf`
    # and `roundeven` on macOS.
    #
    # However these functions are glibc specific so the test fails:
    #   - https://www.gnu.org/software/gnulib/manual/html_node/roundevenf.html
    #   - https://www.gnu.org/software/gnulib/manual/html_node/roundeven.html
    #
    substituteInPlace test/ExecutionEngine/Interpreter/intrinsics.ll \
      --replace "%roundeven32 = call float @llvm.roundeven.f32(float 0.000000e+00)" "" \
      --replace "%roundeven64 = call double @llvm.roundeven.f64(double 0.000000e+00)" ""
  '' + optionalString (!stdenv.hostPlatform.isx86 && lib.versionAtLeast release_version "18") ''

    # fails when run in sandbox
    substituteInPlace unittests/Support/VirtualFileSystemTest.cpp \
      --replace "PhysicalFileSystemWorkingDirFailure" "DISABLED_PhysicalFileSystemWorkingDirFailure"
  ''))) + optionalString (stdenv.isDarwin && stdenv.hostPlatform.isx86 && lib.versionAtLeast release_version "15") (optionalString (lib.versionOlder release_version "16") ''
    # This test tries to call the intrinsics `@llvm.roundeven.f32` and
    # `@llvm.roundeven.f64` which seem to (incorrectly?) lower to `roundevenf`
    # and `roundeven` on x86_64 macOS.
    #
    # However these functions are glibc specific so the test fails:
    #   - https://www.gnu.org/software/gnulib/manual/html_node/roundevenf.html
    #   - https://www.gnu.org/software/gnulib/manual/html_node/roundeven.html
    #
    # TODO(@rrbutani): this seems to run fine on `aarch64-darwin`, why does it
    # pass there?
    substituteInPlace test/ExecutionEngine/Interpreter/intrinsics.ll \
      --replace "%roundeven32 = call float @llvm.roundeven.f32(float 0.000000e+00)" "" \
      --replace "%roundeven64 = call double @llvm.roundeven.f64(double 0.000000e+00)" ""

  '' + ((optionalString (lib.versionAtLeast release_version "18") ''

    # fails when run in sandbox
    substituteInPlace unittests/Support/VirtualFileSystemTest.cpp \
      --replace "PhysicalFileSystemWorkingDirFailure" "DISABLED_PhysicalFileSystemWorkingDirFailure"
  '') + ''
    # This test fails on darwin x86_64 because `sw_vers` reports a different
    # macOS version than what LLVM finds by reading
    # `/System/Library/CoreServices/SystemVersion.plist` (which is passed into
    # the sandbox on macOS).
    #
    # The `sw_vers` provided by nixpkgs reports the macOS version associated
    # with the `CoreFoundation` framework with which it was built. Because
    # nixpkgs pins the SDK for `aarch64-darwin` and `x86_64-darwin` what
    # `sw_vers` reports is not guaranteed to match the macOS version of the host
    # that's building this derivation.
    #
    # Astute readers will note that we only _patch_ this test on aarch64-darwin
    # (to use the nixpkgs provided `sw_vers`) instead of disabling it outright.
    # So why does this test pass on aarch64?
    #
    # Well, it seems that `sw_vers` on aarch64 actually links against the _host_
    # CoreFoundation framework instead of the nixpkgs provided one.
    #
    # Not entirely sure what the right fix is here. I'm assuming aarch64
    # `sw_vers` doesn't intentionally link against the host `CoreFoundation`
    # (still digging into how this ends up happening, will follow up) but that
    # aside I think the more pertinent question is: should we be patching LLVM's
    # macOS version detection logic to use `sw_vers` instead of reading host
    # paths? This *is* a way in which details about builder machines can creep
    # into the artifacts that are produced, affecting reproducibility, but it's
    # not clear to me when/where/for what this even gets used in LLVM.
    #
    # TODO(@rrbutani): fix/follow-up
  '' + (if lib.versionAtLeast release_version "16" then ''
    substituteInPlace unittests/TargetParser/Host.cpp \
      --replace "getMacOSHostVersion" "DISABLED_getMacOSHostVersion"
  '' else ''
    substituteInPlace unittests/Support/Host.cpp \
      --replace "getMacOSHostVersion" "DISABLED_getMacOSHostVersion"
  '') + ''

    # This test fails with a `dysmutil` crash; have not yet dug into what's
    # going on here (TODO(@rrbutani)).
    rm test/tools/dsymutil/ARM/obfuscated.test
  '')) + ''
    # FileSystem permissions tests fail with various special bits
    substituteInPlace unittests/Support/CMakeLists.txt \
      --replace "Path.cpp" ""
    rm unittests/Support/Path.cpp
    substituteInPlace unittests/IR/CMakeLists.txt \
      --replace "PassBuilderCallbacksTest.cpp" ""
    rm unittests/IR/PassBuilderCallbacksTest.cpp
  '' + lib.optionalString (lib.versionAtLeast release_version "13") ''
    rm test/tools/llvm-objcopy/ELF/mirror-permissions-unix.test
  '' + lib.optionalString (lib.versionOlder release_version "13") ''
    # TODO: Fix failing tests:
    rm test/DebugInfo/X86/vla-multi.ll
  '' + lib.optionalString (lib.versionAtLeast release_version "16") (''

    # Fails in the presence of anti-virus software or other intrusion-detection software that
    # modifies the atime when run. See #284056.
    rm test/tools/llvm-objcopy/ELF/strip-preserve-atime.test
  '' + lib.optionalString (lib.versionOlder release_version "17") ''

  '') + lib.optionalString (lib.versionAtLeast release_version "15" && lib.versionOlder release_version "17") ''
    # timing-based tests are trouble
    rm utils/lit/tests/googletest-timeout.py
  '' + optionalString stdenv.hostPlatform.isMusl ''
    patch -p1 -i ${./TLI-musl.patch}
    substituteInPlace unittests/Support/CMakeLists.txt \
      --replace "add_subdirectory(DynamicLibrary)" ""
    rm unittests/Support/DynamicLibrary/DynamicLibraryTest.cpp
    # valgrind unhappy with musl or glibc, but fails w/musl only
    rm test/CodeGen/AArch64/wineh4.mir
  '' + optionalString stdenv.hostPlatform.isAarch32 ''
    # skip failing X86 test cases on 32-bit ARM
    rm test/DebugInfo/X86/convert-debugloc.ll
    rm test/DebugInfo/X86/convert-inlined.ll
    rm test/DebugInfo/X86/convert-linked.ll
    rm test/tools/dsymutil/X86/op-convert.test
    rm test/tools/gold/X86/split-dwarf.ll
    rm test/tools/llvm-objcopy/MachO/universal-object.test
  '' + optionalString (stdenv.hostPlatform.system == "armv6l-linux") ''
    # Seems to require certain floating point hardware (NEON?)
    rm test/ExecutionEngine/frem.ll
  '' + ''
    patchShebangs test/BugPoint/compile-custom.ll.py
  '' + (lib.optionalString (lib.versionOlder release_version "13") ''
    # Tweak tests to ignore namespace part of type to support
    # gcc-12: https://gcc.gnu.org/PR103598.
    # The change below mangles strings like:
    #    CHECK-NEXT: Starting llvm::Function pass manager run.
    # to:
    #    CHECK-NEXT: Starting {{.*}}Function pass manager run.
    for f in \
      test/Other/new-pass-manager.ll \
      test/Other/new-pm-O0-defaults.ll \
      test/Other/new-pm-defaults.ll \
      test/Other/new-pm-lto-defaults.ll \
      test/Other/new-pm-thinlto-defaults.ll \
      test/Other/pass-pipeline-parsing.ll \
      test/Transforms/Inline/cgscc-incremental-invalidate.ll \
      test/Transforms/Inline/clear-analyses.ll \
      test/Transforms/LoopUnroll/unroll-loop-invalidation.ll \
      test/Transforms/SCCP/ipsccp-preserve-analysis.ll \
      test/Transforms/SCCP/preserve-analysis.ll \
      test/Transforms/SROA/dead-inst.ll \
      test/tools/gold/X86/new-pm.ll \
      ; do
      echo "PATCH: $f"
      substituteInPlace $f \
        --replace 'Starting llvm::' 'Starting {{.*}}' \
        --replace 'Finished llvm::' 'Finished {{.*}}'
    done
    # gcc-13 fix
    sed -i '/#include <string>/i#include <cstdint>' \
      include/llvm/DebugInfo/Symbolize/DIPrinter.h
  '');

  preConfigure = if lib.versionAtLeast release_version "15" then ''
    # Workaround for configure flags that need to have spaces
    cmakeFlagsArray+=(
      -DLLVM_LIT_ARGS="-svj''${NIX_BUILD_CORES} --no-progress-bar"
    )
  '' else ''
    # Workaround for configure flags that need to have spaces
    cmakeFlagsArray+=(
      -DLLVM_LIT_ARGS='-svj''${NIX_BUILD_CORES} --no-progress-bar'
    )
  '';

  # E.g. mesa.drivers use the build-id as a cache key (see #93946):
  LDFLAGS = optionalString (enableSharedLibraries && !stdenv.isDarwin) "-Wl,--build-id=sha1";

  cmakeBuildType = if debugVersion then "Debug" else "Release";

  cmakeFlags = with stdenv; let
    # These flags influence llvm-config's BuildVariables.inc in addition to the
    # general build. We need to make sure these are also passed via
    # CROSS_TOOLCHAIN_FLAGS_NATIVE when cross-compiling or llvm-config-native
    # will return different results from the cross llvm-config.
    #
    # Some flags don't need to be repassed because LLVM already does so (like
    # CMAKE_BUILD_TYPE), others are irrelevant to the result.
    flagsForLlvmConfig = (if lib.versionOlder release_version "15" then [
      "-DLLVM_INSTALL_CMAKE_DIR=${placeholder "dev"}/lib/cmake/llvm/"
    ] else [
      "-DLLVM_INSTALL_PACKAGE_DIR=${placeholder "dev"}/lib/cmake/llvm"
    ]) ++ [
      "-DLLVM_ENABLE_RTTI=ON"
    ] ++ optionals enableSharedLibraries [
      "-DLLVM_LINK_LLVM_DYLIB=ON"
    ];
  in flagsForLlvmConfig ++ [
    "-DLLVM_INSTALL_UTILS=ON"  # Needed by rustc
    "-DLLVM_BUILD_TESTS=${if doCheck then "ON" else "OFF"}"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_HOST_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_DEFAULT_TARGET_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_ENABLE_DUMP=ON"
  ] ++ optionals stdenv.hostPlatform.isStatic [
    # Disables building of shared libs, -fPIC is still injected by cc-wrapper
    "-DLLVM_ENABLE_PIC=OFF"
    "-DLLVM_BUILD_STATIC=ON"
    # libxml2 needs to be disabled because the LLVM build system ignores its .la
    # file and doesn't link zlib as well.
    # https://github.com/ClangBuiltLinux/tc-build/issues/150#issuecomment-845418812
    "-DLLVM_ENABLE_LIBXML2=OFF"
  ] ++ optionals enableManpages [
    "-DLLVM_BUILD_DOCS=ON"
    "-DLLVM_ENABLE_SPHINX=ON"
    "-DSPHINX_OUTPUT_MAN=ON"
    "-DSPHINX_OUTPUT_HTML=OFF"
    "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
  ] ++ optionals (enableGoldPlugin) [
    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
  ] ++ optionals isDarwin [
    "-DLLVM_ENABLE_LIBCXX=ON"
    "-DCAN_TARGET_i386=false"
  ] ++ optionals ((stdenv.hostPlatform != stdenv.buildPlatform) && !(stdenv.buildPlatform.canExecute stdenv.hostPlatform)) [
    "-DCMAKE_CROSSCOMPILING=True"
    "-DLLVM_TABLEGEN=${buildLlvmTools.llvm}/bin/llvm-tblgen"
    (
      let
        nativeCC = pkgsBuildBuild.targetPackages.stdenv.cc;
        nativeBintools = nativeCC.bintools.bintools;
        nativeToolchainFlags = [
          "-DCMAKE_C_COMPILER=${nativeCC}/bin/${nativeCC.targetPrefix}cc"
          "-DCMAKE_CXX_COMPILER=${nativeCC}/bin/${nativeCC.targetPrefix}c++"
          "-DCMAKE_AR=${nativeBintools}/bin/${nativeBintools.targetPrefix}ar"
          "-DCMAKE_STRIP=${nativeBintools}/bin/${nativeBintools.targetPrefix}strip"
          "-DCMAKE_RANLIB=${nativeBintools}/bin/${nativeBintools.targetPrefix}ranlib"
        ];
        # We need to repass the custom GNUInstallDirs values, otherwise CMake
        # will choose them for us, leading to wrong results in llvm-config-native
        nativeInstallFlags = [
          "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
          "-DCMAKE_INSTALL_BINDIR=${placeholder "out"}/bin"
          "-DCMAKE_INSTALL_INCLUDEDIR=${placeholder "dev"}/include"
          "-DCMAKE_INSTALL_LIBDIR=${placeholder "lib"}/lib"
          "-DCMAKE_INSTALL_LIBEXECDIR=${placeholder "lib"}/libexec"
        ];
      in "-DCROSS_TOOLCHAIN_FLAGS_NATIVE:list="
      + lib.concatStringsSep ";" (lib.concatLists [
        flagsForLlvmConfig
        nativeToolchainFlags
        nativeInstallFlags
      ])
    )
  ];

  postInstall = ''
    mkdir -p $python/share
    mv $out/share/opt-viewer $python/share/opt-viewer
    moveToOutput "bin/llvm-config*" "$dev"
    substituteInPlace "$dev/lib/cmake/llvm/LLVMExports-${if debugVersion then "debug" else "release"}.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/lib" "$lib/lib/lib" \
      --replace "$out/bin/llvm-config" "$dev/bin/llvm-config"
  '' + (if lib.versionOlder release_version "15" then ''
    substituteInPlace "$dev/lib/cmake/llvm/LLVMConfig.cmake" \
      --replace 'set(LLVM_BINARY_DIR "''${LLVM_INSTALL_PREFIX}")' 'set(LLVM_BINARY_DIR "''${LLVM_INSTALL_PREFIX}'"$lib"'")'
  '' else ''
    substituteInPlace "$dev/lib/cmake/llvm/LLVMConfig.cmake" \
      --replace 'set(LLVM_BINARY_DIR "''${LLVM_INSTALL_PREFIX}")' 'set(LLVM_BINARY_DIR "'"$lib"'")'
  '')
  + optionalString (stdenv.isDarwin && enableSharedLibraries && lib.versionOlder release_version "18") ''
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${shortVersion}.dylib
  ''
  + optionalString (stdenv.isDarwin && enableSharedLibraries) ''
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${release_version}.dylib
  ''
  + optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    cp NATIVE/bin/llvm-config $dev/bin/llvm-config-native
  '';

  inherit doCheck;

  checkTarget = "check-all";

  # For the update script:
  passthru.monorepoSrc = monorepoSrc;

  requiredSystemFeatures = [ "big-parallel" ];
  meta = llvm_meta // {
    homepage = "https://llvm.org/";
    description = "A collection of modular and reusable compiler and toolchain technologies";
    longDescription = ''
      The LLVM Project is a collection of modular and reusable compiler and
      toolchain technologies. Despite its name, LLVM has little to do with
      traditional virtual machines. The name "LLVM" itself is not an acronym; it
      is the full name of the project.
      LLVM began as a research project at the University of Illinois, with the
      goal of providing a modern, SSA-based compilation strategy capable of
      supporting both static and dynamic compilation of arbitrary programming
      languages. Since then, LLVM has grown to be an umbrella project consisting
      of a number of subprojects, many of which are being used in production by
      a wide variety of commercial and open source projects as well as being
      widely used in academic research. Code in the LLVM project is licensed
      under the "Apache 2.0 License with LLVM exceptions".
    '';
  };
} // lib.optionalAttrs enableManpages ({
  pname = "llvm-manpages";

  propagatedBuildInputs = [];

  postPatch = null;
  postInstall = null;

  outputs = [ "out" ];

  doCheck = false;

  meta = llvm_meta // {
    description = "man pages for LLVM ${version}";
  };
} // (if lib.versionOlder release_version "15" then {
  buildPhase = ''
    make docs-llvm-man
  '';

  installPhase = ''
    make -C docs install
  '';
} else {
  ninjaFlags = [ "docs-llvm-man" ];
  installTargets = [ "install-docs-llvm-man" ];

  postPatch = null;
  postInstall = null;
})) // lib.optionalAttrs (lib.versionOlder release_version "13") {
  inherit polly_src;

  unpackPhase = ''
    unpackFile $src
    mv llvm-${release_version}* llvm
    sourceRoot=$PWD/llvm
  '' + optionalString enablePolly ''
    unpackFile $polly_src
    mv polly-* $sourceRoot/tools/polly
  '';
} // lib.optionalAttrs (lib.versionAtLeast release_version "13") {
  nativeCheckInputs = [ which ] ++ lib.optional (stdenv.isDarwin && lib.versionAtLeast release_version "15") sysctl;
} // lib.optionalAttrs (lib.versionOlder release_version "15") {
  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';

  postBuild = ''
    rm -fR $out
  '';

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD/lib
  '';
} // lib.optionalAttrs (lib.versionAtLeast release_version "15") {
  # Defensive check: some paths (that we make symlinks to) depend on the release
  # version, for example:
  #  - https://github.com/llvm/llvm-project/blob/406bde9a15136254f2b10d9ef3a42033b3cb1b16/clang/lib/Headers/CMakeLists.txt#L185
  #
  # So we want to sure that the version in the source matches the release
  # version we were given.
  #
  # We do this check here, in the LLVM build, because it happens early.
  postConfigure = let
    v = lib.versions;
    major = v.major release_version;
    minor = v.minor release_version;
    patch = v.patch release_version;
  in ''
    # $1: part, $2: expected
    check_version() {
      part="''${1^^}"
      part="$(cat include/llvm/Config/llvm-config.h  | grep "#define LLVM_VERSION_''${part} " | cut -d' ' -f3)"

      if [[ "$part" != "$2" ]]; then
        echo >&2 \
          "mismatch in the $1 version! we have version ${release_version}" \
          "and expected the $1 version to be '$2'; the source has '$part' instead"
        exit 3
      fi
    }

    check_version major ${major}
    check_version minor ${minor}
    check_version patch ${patch}
  '';
} // lib.optionalAttrs (lib.versionOlder release_version "17" || lib.versionAtLeast release_version "18") {
  hardeningDisable = [ "trivialautovarinit" ];
})
