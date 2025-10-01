{
  lib,
  stdenv,
  llvm_meta,
  pkgsBuildBuild,
  src ? null,
  monorepoSrc ? null,
  runCommand,
  cmake,
  darwin,
  ninja,
  python3,
  python3Packages,
  libffi,
  ld64,
  libbfd,
  libpfm,
  libxml2,
  ncurses,
  version,
  release_version,
  zlib,
  which,
  sysctl,
  buildLlvmTools,
  updateAutotoolsGnuConfigScriptsHook,
  enableManpages ? false,
  enableSharedLibraries ? !stdenv.hostPlatform.isStatic,
  enablePFM ?
    stdenv.hostPlatform.isLinux # PFM only supports Linux
    # broken for Ampere eMAG 8180 (c2.large.arm on Packet) #56245
    # broken for the armv7l builder
    && !stdenv.hostPlatform.isAarch,
  enablePolly ? true,
  enableTerminfo ? true,
  devExtraCmakeFlags ? [ ],
  getVersionFile,
  fetchpatch,
  # for tests
  libllvm,
}:

let
  inherit (lib) optional optionals optionalString;

  # Is there a better way to do this? Darwin wants to disable tests in the first
  # LLVM rebuild, but overriding doesn’t work when building libc++, libc++abi,
  # and libunwind. It also wants to disable LTO in the first rebuild.
  isDarwinBootstrap = lib.getName stdenv == "bootstrap-stage-xclang-stdenv-darwin";
in

stdenv.mkDerivation (
  finalAttrs:
  let
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
    python =
      if finalAttrs.finalPackage.doCheck && !isDarwinBootstrap then
        # Note that we _explicitly_ ask for a python interpreter for our host
        # platform here; the splicing that would ordinarily take care of this for
        # us does not seem to work once we use `withPackages`.
        let
          checkDeps = ps: [ ps.psutil ];
        in
        pkgsBuildBuild.targetPackages.python3.withPackages checkDeps
      else
        python3;
  in
  {
    pname = "llvm";
    inherit version;

    # TODO: Remove on `staging`.
    shortVersion = lib.concatStringsSep "." (lib.take 1 (lib.splitString "." release_version));

    src =
      if monorepoSrc != null then
        runCommand "llvm-src-${version}" { inherit (monorepoSrc) passthru; } (
          ''
            mkdir -p "$out"
            cp -r ${monorepoSrc}/llvm "$out"
            cp -r ${monorepoSrc}/cmake "$out"
            cp -r ${monorepoSrc}/third-party "$out"
          ''
          + lib.optionalString enablePolly ''
            chmod u+w "$out/llvm/tools"
            cp -r ${monorepoSrc}/polly "$out/llvm/tools"
          ''
          + lib.optionalString (lib.versionAtLeast release_version "21") ''
            cp -r ${monorepoSrc}/libc "$out"
          ''
        )
      else
        src;

    sourceRoot = "${finalAttrs.src.name}/llvm";

    outputs = [
      "out"
      "lib"
      "dev"
      "python"
    ];

    hardeningDisable = [
      "trivialautovarinit"
      "shadowstack"
    ];

    patches =
      # Support custom installation dirs
      # Originally based off https://reviews.llvm.org/D99484
      # Latest state: https://github.com/llvm/llvm-project/pull/125376
      [ (getVersionFile "llvm/gnu-install-dirs.patch") ]
      ++ [
        # Running the tests involves invoking binaries (like `opt`) that depend on
        # the LLVM dylibs and reference them by absolute install path (i.e. their
        # nix store path).
        #
        # Because we have not yet run the install phase (we're running these tests
        # as part of `checkPhase` instead of `installCheckPhase`) these absolute
        # paths do not exist yet; to work around this we point the loader (`ld` on
        # unix, `dyld` on macOS) at the `lib` directory which will later become this
        # package's `lib` output.
        #
        # Previously we would just set `LD_LIBRARY_PATH` to include the build `lib`
        # dir but:
        #   - this doesn't generalize well to other platforms; `lit` doesn't forward
        #     `DYLD_LIBRARY_PATH` (macOS):
        #     + https://github.com/llvm/llvm-project/blob/0d89963df354ee309c15f67dc47c8ab3cb5d0fb2/llvm/utils/lit/lit/TestingConfig.py#L26
        #   - even if `lit` forwarded this env var, we actually cannot set
        #     `DYLD_LIBRARY_PATH` in the child processes `lit` launches because
        #     `DYLD_LIBRARY_PATH` (and `DYLD_FALLBACK_LIBRARY_PATH`) is cleared for
        #     "protected processes" (i.e. the python interpreter that runs `lit`):
        #     https://stackoverflow.com/a/35570229
        #   - other LLVM subprojects deal with this issue by having their `lit`
        #     configuration set these env vars for us; it makes sense to do the same
        #     for LLVM:
        #     + https://github.com/llvm/llvm-project/blob/4c106cfdf7cf7eec861ad3983a3dd9a9e8f3a8ae/clang-tools-extra/test/Unit/lit.cfg.py#L22-L31
        #
        # !!! TODO: look into upstreaming this patch
        (getVersionFile "llvm/llvm-lit-cfg-add-libs-to-dylib-path.patch")

        # `lit` has a mode where it executes run lines as a shell script which is
        # constructs; this is problematic for macOS because it means that there's
        # another process in between `lit` and the binaries being tested. As noted
        # above, this means that `DYLD_LIBRARY_PATH` is cleared which means that our
        # tests fail with dyld errors.
        #
        # To get around this we patch `lit` to reintroduce `DYLD_LIBRARY_PATH`, when
        # present in the test configuration.
        #
        # It's not clear to me why this isn't an issue for LLVM developers running
        # on macOS (nothing about this _seems_ nix specific)..
        (getVersionFile "llvm/lit-shell-script-runner-set-dyld-library-path.patch")
      ]
      ++
        lib.optional (lib.versionOlder release_version "19")
          # Add missing include headers to build against gcc-15:
          #   https://github.com/llvm/llvm-project/pull/101761
          (
            fetchpatch {
              url = "https://github.com/llvm/llvm-project/commit/7e44305041d96b064c197216b931ae3917a34ac1.patch";
              hash = "sha256-1htuzsaPHbYgravGc1vrR8sqpQ/NSQ8PUZeAU8ucCFk=";
              stripLen = 1;
            }
          )
      ++ lib.optionals (lib.versions.major release_version == "18") [
        # Reorgs one test so the next patch applies
        (fetchpatch {
          name = "osabi-test-reorg.patch";
          url = "https://github.com/llvm/llvm-project/commit/06cecdc60ec9ebfdd4d8cdb2586d201272bdf6bd.patch";
          stripLen = 1;
          hash = "sha256-s9GZTNgzLS511Pzh6Wb1hEV68lxhmLWXjlybHBDMhvM=";
        })
        # Sets the OSABI for OpenBSD, needed for an LLD patch for OpenBSD.
        # https://github.com/llvm/llvm-project/pull/98553
        (fetchpatch {
          name = "mc-set-openbsd-osabi.patch";
          url = "https://github.com/llvm/llvm-project/commit/b64c1de714c50bec7493530446ebf5e540d5f96a.patch";
          stripLen = 1;
          hash = "sha256-fqw5gTSEOGs3kAguR4tINFG7Xja1RAje+q67HJt2nGg=";
        })
      ]
      ++ lib.optionals (lib.versionOlder release_version "19") [
        # Fixes test-suite on glibc 2.40 (https://github.com/llvm/llvm-project/pull/100804)
        (fetchpatch {
          url = "https://github.com/llvm/llvm-project/commit/1e8df9e85a1ff213e5868bd822877695f27504ad.patch";
          hash = "sha256-mvBlG2RxpZPFnPI7jvCMz+Fc8JuM15Ye3th1FVZMizE=";
          stripLen = 1;
        })
      ]
      ++ lib.optionals enablePolly [
        # Just like the `gnu-install-dirs` patch, but for `polly`.
        (getVersionFile "llvm/gnu-install-dirs-polly.patch")
        # Just like the `llvm-lit-cfg` patch, but for `polly`.
        (getVersionFile "llvm/polly-lit-cfg-add-libs-to-dylib-path.patch")
      ]
      ++
        lib.optional (lib.versions.major release_version == "20")
          # Test failure on riscv64, fixed in llvm 21
          # https://github.com/llvm/llvm-project/issues/150818
          (
            fetchpatch {
              url = "https://github.com/llvm/llvm-project/commit/bd49bbaaafc98433a2cb4e95ce25b7a201baf5a5.patch";
              hash = "sha256-3hkbYPUVRAtWpo5qBmc2jLZLivURMx8T0GQomvNZesc=";
              stripLen = 1;
            }
          );

    nativeBuildInputs = [
      cmake
      # while this is not an autotools build, it still includes a config.guess
      # this is needed until scripts are updated to not use /usr/bin/uname on FreeBSD native
      updateAutotoolsGnuConfigScriptsHook
      python
      ninja
    ]
    ++ optionals enableManpages [
      # Note: we intentionally use `python3Packages` instead of `python3.pkgs`;
      # splicing does *not* work with the latter. (TODO: fix)
      python3Packages.sphinx
      python3Packages.myst-parser
    ];

    buildInputs = [
      libxml2
      libffi
    ]
    ++ optional enablePFM libpfm; # exegesis

    propagatedBuildInputs = [
      ncurses
      zlib
    ];

    nativeCheckInputs = [
      which
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin sysctl;

    postPatch =
      optionalString stdenv.hostPlatform.isDarwin (
        ''
          substituteInPlace cmake/modules/AddLLVM.cmake \
            --replace-fail 'set(_install_name_dir INSTALL_NAME_DIR "@rpath")' "set(_install_name_dir)"
        ''
        +
          # As of LLVM 15, marked as XFAIL on arm64 macOS but lit doesn't seem to pick
          # this up: https://github.com/llvm/llvm-project/blob/c344d97a125b18f8fed0a64aace73c49a870e079/llvm/test/MC/ELF/cfi-version.ll#L7
          ''
            rm test/MC/ELF/cfi-version.ll

          ''
        +
          # This test tries to call `sw_vers` by absolute path (`/usr/bin/sw_vers`)
          # and thus fails under the sandbox:
          ''
            substituteInPlace unittests/TargetParser/Host.cpp \
              --replace-fail '/usr/bin/sw_vers' "${(builtins.toString darwin.DarwinTools) + "/bin/sw_vers"}"
          ''
        +
          # This test tries to call the intrinsics `@llvm.roundeven.f32` and
          # `@llvm.roundeven.f64` which seem to (incorrectly?) lower to `roundevenf`
          # and `roundeven` on macOS and FreeBSD.
          #
          # However these functions are glibc specific so the test fails:
          #   - https://www.gnu.org/software/gnulib/manual/html_node/roundevenf.html
          #   - https://www.gnu.org/software/gnulib/manual/html_node/roundeven.html
          #
          # TODO(@rrbutani): this seems to run fine on `aarch64-darwin`, why does it
          # pass there?
          ''
            substituteInPlace test/ExecutionEngine/Interpreter/intrinsics.ll \
              --replace-fail "%roundeven32 = call float @llvm.roundeven.f32(float 0.000000e+00)" "" \
              --replace-fail "%roundeven64 = call double @llvm.roundeven.f64(double 0.000000e+00)" ""
          ''
        +
          # fails when run in sandbox
          optionalString (!stdenv.hostPlatform.isx86) ''
            substituteInPlace unittests/Support/VirtualFileSystemTest.cpp \
              --replace-fail "PhysicalFileSystemWorkingDirFailure" "DISABLED_PhysicalFileSystemWorkingDirFailure"
          ''
      )
      +
        # dup of above patch with different conditions
        optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86) (
          # fails when run in sandbox
          (
            ''
              substituteInPlace unittests/Support/VirtualFileSystemTest.cpp \
                --replace-fail "PhysicalFileSystemWorkingDirFailure" "DISABLED_PhysicalFileSystemWorkingDirFailure"
            ''
            +
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
              ''
                substituteInPlace unittests/TargetParser/Host.cpp \
                  --replace-fail "getMacOSHostVersion" "DISABLED_getMacOSHostVersion"
              ''
            +
              # This test fails with a `dysmutil` crash; have not yet dug into what's
              # going on here (TODO(@rrbutani)).
              lib.optionalString (lib.versionOlder release_version "19") ''
                rm test/tools/dsymutil/ARM/obfuscated.test
              ''
          )
        )
      +
        # FileSystem permissions tests fail with various special bits
        ''
          substituteInPlace unittests/Support/CMakeLists.txt \
            --replace-fail "Path.cpp" ""
          rm unittests/Support/Path.cpp
          substituteInPlace unittests/IR/CMakeLists.txt \
            --replace-fail "PassBuilderCallbacksTest.cpp" ""
          rm unittests/IR/PassBuilderCallbacksTest.cpp
          rm test/tools/llvm-objcopy/ELF/mirror-permissions-unix.test
        ''
      +
        # Fails in the presence of anti-virus software or other intrusion-detection software that
        # modifies the atime when run. See #284056.
        ''
          rm test/tools/llvm-objcopy/ELF/strip-preserve-atime.test
        ''
      +
        # valgrind unhappy with musl or glibc, but fails w/musl only
        optionalString stdenv.hostPlatform.isMusl ''
          patch -p1 -i ${./TLI-musl.patch}
          substituteInPlace unittests/Support/CMakeLists.txt \
            --replace-fail "add_subdirectory(DynamicLibrary)" ""
          rm unittests/Support/DynamicLibrary/DynamicLibraryTest.cpp
          rm test/CodeGen/AArch64/wineh4.mir
        ''
      + optionalString stdenv.hostPlatform.isAarch32 ''
        # skip failing X86 test cases on 32-bit ARM
        rm test/DebugInfo/X86/convert-debugloc.ll
        rm test/DebugInfo/X86/convert-inlined.ll
        rm test/DebugInfo/X86/convert-linked.ll
        rm test/tools/dsymutil/X86/op-convert.test
        rm test/tools/gold/X86/split-dwarf.ll
        rm test/tools/llvm-objcopy/MachO/universal-object.test
      ''
      +
        # Seems to require certain floating point hardware (NEON?)
        optionalString (stdenv.hostPlatform.system == "armv6l-linux") ''
          rm test/ExecutionEngine/frem.ll
        ''
      +
        # 1. TODO: Why does this test fail on FreeBSD?
        # It seems to reference /usr/local/lib/libfile.a, which is clearly a problem.
        # 2. This test fails for the same reason it fails on MacOS, but the fix is
        # not trivial to apply.
        optionalString stdenv.hostPlatform.isFreeBSD ''
          rm test/tools/llvm-libtool-darwin/L-and-l.test
          rm test/ExecutionEngine/Interpreter/intrinsics.ll
          # Fails in sandbox
          substituteInPlace unittests/Support/LockFileManagerTest.cpp --replace-fail "Basic" "DISABLED_Basic"
        ''
      +
        # https://github.com/llvm/llvm-project/issues/149616
        optionalString stdenv.hostPlatform.isLoongArch64 ''
          substituteInPlace unittests/tools/llvm-exegesis/X86/SnippetRepetitorTest.cpp \
            --replace-fail \
              "TEST_F(X86SnippetRepetitorTest, Loop)" \
              "TEST_F(X86SnippetRepetitorTest, DISABLED_Loop)"
        ''
      + ''
        patchShebangs test/BugPoint/compile-custom.ll.py
      '';

    # Workaround for configure flags that need to have spaces
    preConfigure = ''
      cmakeFlagsArray+=(
        -DLLVM_LIT_ARGS="--verbose -j''${NIX_BUILD_CORES}"
      )
    '';

    # Defensive check: some paths (that we make symlinks to) depend on the release
    # version, for example:
    #  - https://github.com/llvm/llvm-project/blob/406bde9a15136254f2b10d9ef3a42033b3cb1b16/clang/lib/Headers/CMakeLists.txt#L185
    #
    # So we want to sure that the version in the source matches the release
    # version we were given.
    #
    # We do this check here, in the LLVM build, because it happens early.
    postConfigure =
      let
        v = lib.versions;
        major = v.major release_version;
        minor = v.minor release_version;
        patch = v.patch release_version;
      in
      ''
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

    # E.g. Mesa uses the build-id as a cache key (see #93946):
    LDFLAGS = optionalString (
      enableSharedLibraries && !stdenv.hostPlatform.isDarwin
    ) "-Wl,--build-id=sha1";

    cmakeBuildType = "Release";

    cmakeFlags =
      let
        # These flags influence llvm-config's BuildVariables.inc in addition to the
        # general build. We need to make sure these are also passed via
        # CROSS_TOOLCHAIN_FLAGS_NATIVE when cross-compiling or llvm-config-native
        # will return different results from the cross llvm-config.
        #
        # Some flags don't need to be repassed because LLVM already does so (like
        # CMAKE_BUILD_TYPE), others are irrelevant to the result.
        flagsForLlvmConfig = [
          (lib.cmakeFeature "LLVM_INSTALL_PACKAGE_DIR" "${placeholder "dev"}/lib/cmake/llvm")
          (lib.cmakeBool "LLVM_ENABLE_RTTI" true)
          (lib.cmakeBool "LLVM_LINK_LLVM_DYLIB" enableSharedLibraries)
          (lib.cmakeFeature "LLVM_TABLEGEN" "${buildLlvmTools.tblgen}/bin/llvm-tblgen")
        ];
      in
      flagsForLlvmConfig
      ++ [
        (lib.cmakeBool "LLVM_INSTALL_UTILS" true) # Needed by rustc
        (lib.cmakeBool "LLVM_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
        (lib.cmakeBool "LLVM_ENABLE_FFI" true)
        (lib.cmakeFeature "LLVM_HOST_TRIPLE" stdenv.hostPlatform.config)
        (lib.cmakeFeature "LLVM_DEFAULT_TARGET_TRIPLE" stdenv.hostPlatform.config)
        (lib.cmakeBool "LLVM_ENABLE_DUMP" true)
        (lib.cmakeBool "LLVM_ENABLE_TERMINFO" enableTerminfo)
        (lib.cmakeBool "LLVM_INCLUDE_TESTS" finalAttrs.finalPackage.doCheck)
      ]
      ++ optionals stdenv.hostPlatform.isStatic [
        # Disables building of shared libs, -fPIC is still injected by cc-wrapper
        (lib.cmakeBool "LLVM_ENABLE_PIC" false)
        (lib.cmakeBool "CMAKE_SKIP_INSTALL_RPATH" true)
        (lib.cmakeBool "LLVM_BUILD_STATIC" true)
        # libxml2 needs to be disabled because the LLVM build system ignores its .la
        # file and doesn't link zlib as well.
        # https://github.com/ClangBuiltLinux/tc-build/issues/150#issuecomment-845418812
        (lib.cmakeBool "LLVM_ENABLE_LIBXML2" false)
      ]
      ++ optionals enableManpages [
        (lib.cmakeBool "LLVM_BUILD_DOCS" true)
        (lib.cmakeBool "LLVM_ENABLE_SPHINX" true)
        (lib.cmakeBool "SPHINX_OUTPUT_MAN" true)
        (lib.cmakeBool "SPHINX_OUTPUT_HTML" false)
        (lib.cmakeBool "SPHINX_WARNINGS_AS_ERRORS" false)
      ]
      ++ optionals (libbfd != null) [
        # LLVM depends on binutils only through libbfd/include/plugin-api.h, which
        # is meant to be a stable interface. Depend on that file directly rather
        # than through a build of BFD to break the dependency of clang on the target
        # triple. The result of this is that a single clang build can be used for
        # multiple targets.
        (lib.cmakeFeature "LLVM_BINUTILS_INCDIR" "${libbfd.plugin-api-header}/include")
      ]
      ++ optionals stdenv.hostPlatform.isDarwin [
        (lib.cmakeBool "LLVM_ENABLE_LIBCXX" true)
        (lib.cmakeBool "CAN_TARGET_i386" false)
      ]
      ++
        optionals
          (
            (stdenv.hostPlatform != stdenv.buildPlatform)
            && !(stdenv.buildPlatform.canExecute stdenv.hostPlatform)
          )
          [
            (lib.cmakeBool "CMAKE_CROSSCOMPILING" true)
            (
              let
                nativeCC = pkgsBuildBuild.targetPackages.stdenv.cc;
                nativeBintools = nativeCC.bintools.bintools;
                nativeToolchainFlags = [
                  (lib.cmakeFeature "CMAKE_C_COMPILER" "${nativeCC}/bin/${nativeCC.targetPrefix}cc")
                  (lib.cmakeFeature "CMAKE_CXX_COMPILER" "${nativeCC}/bin/${nativeCC.targetPrefix}c++")
                  (lib.cmakeFeature "CMAKE_AR" "${nativeBintools}/bin/${nativeBintools.targetPrefix}ar")
                  (lib.cmakeFeature "CMAKE_STRIP" "${nativeBintools}/bin/${nativeBintools.targetPrefix}strip")
                  (lib.cmakeFeature "CMAKE_RANLIB" "${nativeBintools}/bin/${nativeBintools.targetPrefix}ranlib")
                ];
                # We need to repass the custom GNUInstallDirs values, otherwise CMake
                # will choose them for us, leading to wrong results in llvm-config-native
                nativeInstallFlags = [
                  (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" (placeholder "out"))
                  (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "${placeholder "out"}/bin")
                  (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "${placeholder "dev"}/include")
                  (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "${placeholder "lib"}/lib")
                  (lib.cmakeFeature "CMAKE_INSTALL_LIBEXECDIR" "${placeholder "lib"}/libexec")
                ];
              in
              lib.cmakeOptionType "list" "CROSS_TOOLCHAIN_FLAGS_NATIVE" (
                lib.concatStringsSep ";" (
                  lib.concatLists [
                    flagsForLlvmConfig
                    nativeToolchainFlags
                    nativeInstallFlags
                  ]
                )
              )
            )
          ]
      ++ devExtraCmakeFlags;

    postInstall = ''
      mkdir -p $python/share
      mv $out/share/opt-viewer $python/share/opt-viewer
      moveToOutput "bin/llvm-config*" "$dev"
      substituteInPlace "$dev/lib/cmake/llvm/LLVMExports-${lib.toLower finalAttrs.finalPackage.cmakeBuildType}.cmake" \
        --replace-fail "$out/bin/llvm-config" "$dev/bin/llvm-config"
      substituteInPlace "$dev/lib/cmake/llvm/LLVMConfig.cmake" \
        --replace-fail 'set(LLVM_BINARY_DIR "''${LLVM_INSTALL_PREFIX}")' 'set(LLVM_BINARY_DIR "'"$lib"'")'
    ''
    + optionalString (stdenv.hostPlatform.isDarwin && enableSharedLibraries) ''
      ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${release_version}.dylib
    ''
    + optionalString (stdenv.buildPlatform != stdenv.hostPlatform) (
      if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
        ''
          ln -s $dev/bin/llvm-config $dev/bin/llvm-config-native
        ''
      else
        ''
          cp NATIVE/bin/llvm-config $dev/bin/llvm-config-native
        ''
    );

    doCheck =
      !isDarwinBootstrap
      && !stdenv.hostPlatform.isAarch32
      && (
        !stdenv.hostPlatform.isx86_32 # TODO: why
      )
      && (!stdenv.hostPlatform.isMusl)
      && !(stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isBigEndian)
      && (stdenv.hostPlatform == stdenv.buildPlatform);

    checkTarget = "check-all";

    passthru = {
      # For the update script:
      inherit monorepoSrc;
      tests.withoutOptionalFeatures = libllvm.override {
        enablePFM = false;
        enablePolly = false;
        enableTerminfo = false;
      };
    };

    requiredSystemFeatures = [ "big-parallel" ];
    meta = llvm_meta // {
      homepage = "https://llvm.org/";
      description = "Collection of modular and reusable compiler and toolchain technologies";
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
  }
  // lib.optionalAttrs enableManpages {
    pname = "llvm-manpages";

    propagatedBuildInputs = [ ];

    ninjaFlags = [ "docs-llvm-man" ];
    installTargets = [ "install-docs-llvm-man" ];

    doCheck = false;

    postPatch = null;
    postInstall = null;

    outputs = [ "out" ];

    meta = llvm_meta // {
      description = "man pages for LLVM ${version}";
    };
  }
)
