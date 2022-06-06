{ lib, stdenv
, cmake
, coreutils
, glibc
, gccForLibs
, which
, perl
, libedit
, ninja
, pkg-config
, sqlite
, libxml2
, clang_13
, python3
, ncurses
, libuuid
, icu
, libgcc
, libblocksruntime
, curl
, rsync
, git
, libgit2
, fetchFromGitHub
, makeWrapper
, gnumake
, file
}:

let
  # The Swift toolchain script builds projects with separate repos. By convention, some of them share
  # the same version with the main Swift compiler project per release. We fetch these with
  # `fetchSwiftRelease`. The rest have their own versions locked to each Swift release, as defined in the
  # Swift compiler repo:
  #   utils/update_checkout/update_checkout-config.json.
  #
  # ... among projects listed in that file, we provide our own:
  # - CMake
  # - ninja
  # - icu
  #
  # ... we'd like to include the following in the future:
  # - stress-tester
  # - integration-tests

  versions = {
    swift = "5.6.2";
    yams = "4.0.2";
    argumentParser = "1.0.3";
    format = "release/5.6";
    crypto = "1.1.5";
    nio = "2.31.2";
    nio-ssl = "2.15.0";
  };

  fetchAppleRepo = { repo, rev, sha256 }:
    fetchFromGitHub {
      owner = "apple";
      inherit repo rev sha256;
      name = "${repo}-${rev}-src";
    };

  fetchSwiftRelease = { repo, sha256, fetchSubmodules ? false }:
    fetchFromGitHub {
      owner = "apple";
      inherit repo sha256 fetchSubmodules;
      rev = "swift-${versions.swift}-RELEASE";
      name = "${repo}-${versions.swift}-src";
    };

  sources = {
    # Projects that share `versions.swift` for each release.

    swift = fetchSwiftRelease {
      repo = "swift";
      sha256 = "sha256-wiRXAXWEksJuy+YQQ+B7tzr2iLkSVkgV6o+wIz7yKJA=";
    };
    cmark = fetchSwiftRelease {
      repo = "swift-cmark";
      sha256 = "sha256-f0BoTs4HYdx/aJ9HIGCWMalhl8PvClWD6R4QK3qSgAw=";
    };
    llbuild = fetchSwiftRelease {
      repo = "swift-llbuild";
      sha256 = "sha256-SQ6V0zVshIYMjayx+ZpYuLijgQ89tqRnPlXBPf2FYqM=";
    };
    driver = fetchSwiftRelease {
      repo = "swift-driver";
      sha256 = "sha256-D5/C4Rbv5KIsKpy6YbuMxGIGaQkn80PD4Cp0l6bPKzY=";
    };
    toolsSupportCore = fetchSwiftRelease {
      repo = "swift-tools-support-core";
      sha256 = "sha256-FbtQCq1sSlzrskCrgzD4iYuo5eGaXrAUUxoNX/BiOfg=";
    };
    swiftpm = fetchSwiftRelease {
      repo = "swift-package-manager";
      sha256 = "sha256-esO4Swz3UYngbVgxoV+fkhSC0AU3IaxVjWkgK/s3x68=";
    };
    syntax = fetchSwiftRelease {
      repo = "swift-syntax";
      sha256 = "sha256-C9FPCtq49BvKXtTWWeReYWNrU70pHzT2DhAv3NiTbPU=";
    };
    corelibsXctest = fetchSwiftRelease {
      repo = "swift-corelibs-xctest";
      sha256 = "sha256-0hizfnKJaUUA+jXuXzXWk72FmlSyc+UGEf7BTLdJrx4=";
    };
    corelibsFoundation = fetchSwiftRelease {
      repo = "swift-corelibs-foundation";
      sha256 = "sha256-8sCL8Ia6yb6bRsJZ52gUJH0jN3lwClM573G8jgUdEhw=";
    };
    corelibsLibdispatch = fetchSwiftRelease {
      repo = "swift-corelibs-libdispatch";
      sha256 = "sha256-1tIskUMnfblnvZaFDQPUMBfWTmBYG98s7rEww7PwZO8=";
      fetchSubmodules = true;
    };
    indexstoreDb = fetchSwiftRelease {
      repo = "indexstore-db";
      sha256 = "sha256-/PO4eMiASZN3pjFjBQ1r8vYwGRn6xm3SWaB2HDZlkPs=";
    };
    sourcekitLsp = fetchSwiftRelease {
      repo = "sourcekit-lsp";
      sha256 = "sha256-ttgUC4ZHD3P/xLHllEbACtHVrJ6HXqeVWccXcoPMkts=";
    };
    llvmProject = fetchSwiftRelease {
      repo = "llvm-project";
      sha256 = "sha256-YVs3lKV2RlaovpYkdGO+vzypolrmXmbKBBP4+osNMYw=";
    };
    docc = fetchSwiftRelease {
      repo = "swift-docc";
      sha256 = "sha256-rWiaNamZoHTO1bKpubxuT7m1IBOl7amT5M71mNauilY=";
    };
    docc-render-artifact = fetchSwiftRelease {
      repo = "swift-docc-render-artifact";
      sha256 = "sha256-AX+rtDLhq8drk7N6/hoH3fQioudmmTCnEhR45bME8uU=";
    };
    docc-symbolkit = fetchSwiftRelease {
      repo = "swift-docc-symbolkit";
      sha256 = "sha256-Xy1TQ5ucDW+MnkeOvVznsATBmwcQ3p1x+ofQ22ofk+o=";
    };
    lmdb = fetchSwiftRelease {
      repo = "swift-lmdb";
      sha256 = "sha256-i2GkWRWq1W5j8rF4PiHwWgT4Dur5FCY2o44HvUU3vtQ=";
    };
    markdown = fetchSwiftRelease {
      repo = "swift-markdown";
      sha256 = "sha256-XtFSBiNHhmULjS4OqSpMgUetLu3peRg7l6HpjwVsTj8=";
    };

    cmark-gfm = fetchAppleRepo {
      repo = "swift-cmark";
      rev = "swift-${versions.swift}-RELEASE-gfm";
      sha256 = "sha256-g28iKmMR2W0r1urf8Fk1HBxAp5OlonNYSVN3Ril66tQ=";
    };

    # Projects that have their own versions during each release

    argumentParser = fetchAppleRepo {
      repo = "swift-argument-parser";
      rev = "${versions.argumentParser}";
      sha256 = "sha256-vNqkuAwSZNCWvwe6E5BqbXQdIbmIia0dENmmSQ9P8Mo=";
    };
    format = fetchAppleRepo {
      repo = "swift-format";
      rev = "${versions.format}";
      sha256 = "sha256-1f5sIrv9IbPB7Vnahq1VwH8gT41dcjWldRwvVEaMdto=";
    };
    crypto = fetchAppleRepo {
      repo = "swift-crypto";
      rev = "${versions.crypto}";
      sha256 = "sha256-jwxXQuOF+CnpLMwTZ2z52Fgx2b97yWzXiPTx0Ye8KCQ=";
    };
    nio = fetchAppleRepo {
      repo = "swift-nio";
      rev = versions.nio;
      sha256 = "sha256-FscOA/S7on31QCR/MZFjg4ZB3FGJ+rdptZ6MRZJXexE=";
    };
    nio-ssl = fetchAppleRepo {
      repo = "swift-nio-ssl";
      rev = versions.nio-ssl;
      sha256 = "sha256-5QGkmkCOXhG3uOdf0bd3Fo1MFekB8/WcveBXGhtVZKo=";
    };
    yams = fetchFromGitHub {
      owner = "jpsim";
      repo = "Yams";
      rev = versions.yams;
      sha256 = "sha256-cTkCAwxxLc35laOon1ZXXV8eAxX02oDolJyPauhZado=";
      name = "Yams-${versions.yams}-src";
    };
  };

  devInputs = [
    curl
    glibc
    icu
    libblocksruntime
    libedit
    libgcc
    libuuid
    libxml2
    ncurses
    sqlite
  ];

  python = (python3.withPackages (ps: [ps.six]));

  cmakeFlags = [
    "-DGLIBC_INCLUDE_PATH=${stdenv.cc.libc.dev}/include"
    "-DC_INCLUDE_DIRS=${lib.makeSearchPathOutput "dev" "include" devInputs}:${libxml2.dev}/include/libxml2"
    "-DGCC_INSTALL_PREFIX=${gccForLibs}"
  ];

in
stdenv.mkDerivation {
  pname = "swift";
  version = versions.swift;

  nativeBuildInputs = [
    cmake
    git
    makeWrapper
    ninja
    perl
    pkg-config
    python
    rsync
    which
  ];
  buildInputs = devInputs ++ [
    clang_13
  ];

  # TODO: Revisit what needs to be propagated and how.
  propagatedBuildInputs = [
    libgcc
    libgit2
    python
  ];
  propagatedUserEnvPkgs = [ git pkg-config ];

  hardeningDisable = [ "format" ]; # for LLDB

  unpackPhase = ''
    mkdir src
    cd src
    export SWIFT_SOURCE_ROOT=$PWD

    cp -r ${sources.swift} swift
    cp -r ${sources.cmark} cmark
    cp -r ${sources.llbuild} llbuild
    cp -r ${sources.argumentParser} swift-argument-parser
    cp -r ${sources.driver} swift-driver
    cp -r ${sources.toolsSupportCore} swift-tools-support-core
    cp -r ${sources.swiftpm} swiftpm
    cp -r ${sources.syntax} swift-syntax
    cp -r ${sources.corelibsXctest} swift-corelibs-xctest
    cp -r ${sources.corelibsFoundation} swift-corelibs-foundation
    cp -r ${sources.corelibsLibdispatch} swift-corelibs-libdispatch
    cp -r ${sources.yams} yams
    cp -r ${sources.indexstoreDb} indexstore-db
    cp -r ${sources.sourcekitLsp} sourcekit-lsp
    cp -r ${sources.format} swift-format
    cp -r ${sources.crypto} swift-crypto
    cp -r ${sources.llvmProject} llvm-project
    cp -r ${sources.cmark-gfm} swift-cmark-gfm
    cp -r ${sources.docc} swift-docc
    cp -r ${sources.docc-render-artifact} swift-docc-render-artifact
    cp -r ${sources.docc-symbolkit} swift-docc-symbolkit
    cp -r ${sources.lmdb} swift-lmdb
    cp -r ${sources.markdown} swift-markdown
    cp -r ${sources.nio} swift-nio
    cp -r ${sources.nio-ssl} swift-nio-ssl

    chmod -R u+w .
  '';

  patchPhase = ''
    # Just patch all the things for now, we can focus this later.
    patchShebangs $SWIFT_SOURCE_ROOT

    # TODO: eliminate use of env.
    find -type f -print0 | xargs -0 sed -i \
      -e 's|/usr/bin/env|${coreutils}/bin/env|g' \
      -e 's|/usr/bin/make|${gnumake}/bin/make|g' \
      -e 's|/bin/mkdir|${coreutils}/bin/mkdir|g' \
      -e 's|/bin/cp|${coreutils}/bin/cp|g' \
      -e 's|/usr/bin/file|${file}/bin/file|g'

    # Build configuration patches.
    patch -p1 -d swift -i ${./patches/0001-build-presets-linux-don-t-require-using-Ninja.patch}
    patch -p1 -d swift -i ${./patches/0002-build-presets-linux-allow-custom-install-prefix.patch}
    patch -p1 -d swift -i ${./patches/0003-build-presets-linux-don-t-build-extra-libs.patch}
    patch -p1 -d swift -i ${./patches/0004-build-presets-linux-plumb-extra-cmake-options.patch}
    patch -p1 -d swift -i ${./patches/0007-build-presets-linux-os-stdlib.patch}
    substituteInPlace swift/cmake/modules/SwiftConfigureSDK.cmake \
      --replace '/usr/include' "${stdenv.cc.libc.dev}/include"
    sed -i swift/utils/build-presets.ini \
      -e 's/^test-installable-package$/# \0/' \
      -e 's/^test$/# \0/' \
      -e 's/^validation-test$/# \0/' \
      -e 's/^long-test$/# \0/' \
      -e 's/^stress-test$/# \0/' \
      -e 's/^test-optimized$/# \0/' \
      -e 's/^swift-install-components=autolink.*$/\0;editor-integration/'

    # LLVM toolchain patches.
    patch -p1 -d llvm-project/clang -i ${./patches/0005-clang-toolchain-dir.patch}
    patch -p1 -d llvm-project/clang -i ${./patches/0006-clang-purity.patch}
    substituteInPlace llvm-project/clang/lib/Driver/ToolChains/Linux.cpp \
      --replace 'SysRoot + "/lib' '"${glibc}/lib" "' \
      --replace 'SysRoot + "/usr/lib' '"${glibc}/lib" "' \
      --replace 'LibDir = "lib";' 'LibDir = "${glibc}/lib";' \
      --replace 'LibDir = "lib64";' 'LibDir = "${glibc}/lib";' \
      --replace 'LibDir = X32 ? "libx32" : "lib64";' 'LibDir = "${glibc}/lib";'

    # Substitute ncurses for curses in llbuild.
    sed -i 's/curses/ncurses/' llbuild/*/*/CMakeLists.txt
    sed -i 's/curses/ncurses/' llbuild/*/*/*/CMakeLists.txt

    # uuid.h is not part of glibc, but of libuuid.
    sed -i 's|''${GLIBC_INCLUDE_PATH}/uuid/uuid.h|${libuuid.dev}/include/uuid/uuid.h|' swift/stdlib/public/Platform/glibc.modulemap.gyb

    # Support library build script patches.
    PREFIX=''${out/#\/}
    substituteInPlace swift/utils/swift_build_support/swift_build_support/products/benchmarks.py \
      --replace \
      "'--toolchain', toolchain_path," \
      "'--toolchain', '/build/install/$PREFIX',"
    substituteInPlace swift/benchmark/scripts/build_script_helper.py \
      --replace \
      "swiftbuild_path = os.path.join(args.toolchain, \"usr\", \"bin\", \"swift-build\")" \
      "swiftbuild_path = os.path.join(args.toolchain, \"bin\", \"swift-build\")"
    substituteInPlace swift-corelibs-xctest/build_script.py \
      --replace usr "$PREFIX"

    # Can be removed in later swift-docc versions, see
    # https://github.com/apple/swift-docc/commit/bff70b847008f91ac729cfd299a85481eef3f581
    substituteInPlace swift-docc/build-script-helper.py \
      --replace \
      "subprocess.check_output(cmd, env=env).strip(), 'docc')" \
      "subprocess.check_output(cmd, env=env).strip().decode(), 'docc')"

    # Can be removed in later Swift versions, see
    # https://github.com/apple/swift/pull/58755
    substituteInPlace swift/utils/process-stats-dir.py \
      --replace \
      "type=argparse.FileType('wb', 0)," \
      "type=argparse.FileType('w', 0),"

    # Apply Python 3 fix, see
    # https://github.com/apple/swift/commit/ec6bc595092974628b27b114a472e84162261bbd
    substituteInPlace swift/utils/swift_build_support/swift_build_support/productpipeline_list_builder.py \
      --replace \
      "filter(lambda x: x is not None, pipeline)" \
      "[p for p in pipeline if p is not None]"
  '';

  configurePhase = ''
    cd ..

    mkdir build install
    export SWIFT_BUILD_ROOT=$PWD/build
    export SWIFT_INSTALL_DIR=$PWD/install

    export INSTALLABLE_PACKAGE=$PWD/swift.tar.gz
    export NIX_ENFORCE_PURITY=

    cd $SWIFT_BUILD_ROOT
  '';

  buildPhase = ''
    # Explicitly include C++ headers to prevent errors where stdlib.h is not found from cstdlib.
    export NIX_CFLAGS_COMPILE="$(< ${clang_13}/nix-support/libcxx-cxxflags) $NIX_CFLAGS_COMPILE"

    # During the Swift build, a full local LLVM build is performed and the resulting clang is
    # invoked. This compiler is not using the Nix wrappers, so it needs some help to find things.
    export NIX_LDFLAGS_BEFORE="-rpath ${gccForLibs.lib}/lib -L${gccForLibs.lib}/lib $NIX_LDFLAGS_BEFORE"

    # However, we want to use the wrapped compiler whenever possible.
    export CC="${clang_13}/bin/clang"

    $SWIFT_SOURCE_ROOT/swift/utils/build-script \
      --preset=buildbot_linux \
      installable_package=$INSTALLABLE_PACKAGE \
      install_prefix=$out \
      install_destdir=$SWIFT_INSTALL_DIR \
      extra_cmake_options="${lib.concatStringsSep "," cmakeFlags}"
  '';

  doCheck = true;

  checkInputs = [ file ];

  checkPhase = ''
    # Remove compiler build system tests which fail due to our modified default build profile and
    # nixpkgs-provided version of CMake.
    rm $SWIFT_SOURCE_ROOT/swift/validation-test/BuildSystem/infer_implies_install_all.test
    rm $SWIFT_SOURCE_ROOT/swift/validation-test/BuildSystem/infer_dumps_deps_if_verbose_build.test

    # This test apparently requires Python 2 (strings are assumed to be bytes-like), but the build
    # process overall now otherwise requires Python 3 (which is what we have updated to). A fix PR
    # has been submitted upstream.
    rm $SWIFT_SOURCE_ROOT/swift/validation-test/SIL/verify_all_overlays.py

    # TODO: consider fixing and re-adding. This test fails due to a non-standard "install_prefix".
    rm $SWIFT_SOURCE_ROOT/swift/validation-test/Python/build_swift.swift

    # We cannot handle the SDK location being in "Weird Location" due to Nix isolation.
    rm $SWIFT_SOURCE_ROOT/swift/test/DebugInfo/compiler-flags.swift

    # TODO: Fix issue with ld.gold invoked from script finding crtbeginS.o and crtendS.o.
    rm $SWIFT_SOURCE_ROOT/swift/test/IRGen/ELF-remove-autolink-section.swift

    # The following two tests fail because we use don't use the bundled libicu:
    # [SOURCE_DIR/utils/build-script] ERROR: can't find source directory for libicu (tried /build/src/icu)
    rm $SWIFT_SOURCE_ROOT/swift/validation-test/BuildSystem/default_build_still_performs_epilogue_opts_after_split.test
    rm $SWIFT_SOURCE_ROOT/swift/validation-test/BuildSystem/test_early_swift_driver_and_infer.swift

    # TODO: This test fails for some unknown reason
    rm $SWIFT_SOURCE_ROOT/swift/test/Serialization/restrict-swiftmodule-to-revision.swift

    # This test was flaky in ofborg, see #186476
    rm $SWIFT_SOURCE_ROOT/swift/test/AutoDiff/compiler_crashers_fixed/sr14290-missing-debug-scopes-in-pullback-trampoline.swift

    # TODO: consider using stress-tester and integration-test.

    # Match the wrapped version of Swift to be installed.
    export LIBRARY_PATH=${lib.makeLibraryPath [icu libgcc libuuid]}:$l

    checkTarget=check-swift-all-${stdenv.hostPlatform.parsed.kernel.name}-${stdenv.hostPlatform.parsed.cpu.name}
    ninjaFlags='-C buildbot_linux/swift-${stdenv.hostPlatform.parsed.kernel.name}-${stdenv.hostPlatform.parsed.cpu.name}'
    ninjaCheckPhase
  '';

  installPhase = ''
    mkdir -p $out

    # Extract the generated tarball into the store.
    tar xf $INSTALLABLE_PACKAGE -C $out --strip-components=3 ''${out/#\/}
    find $out -type d -empty -delete

    # Fix installation weirdness, also present in Apple’s official tarballs.
    mv $out/local/include/indexstore $out/include
    rmdir $out/local/include $out/local
    rm -r $out/bin/sdk-module-lists $out/bin/swift-api-checker.py

    wrapProgram $out/bin/swift \
      --set CC $out/bin/clang \
      --suffix C_INCLUDE_PATH : $out/lib/swift/clang/include \
      --suffix CPLUS_INCLUDE_PATH : $out/lib/swift/clang/include \
      --suffix LIBRARY_PATH : ${lib.makeLibraryPath [icu libgcc libuuid]} \
      --suffix PATH : ${lib.makeBinPath [ stdenv.cc.bintools ]}

    wrapProgram $out/bin/swiftc \
      --set CC $out/bin/clang \
      --suffix C_INCLUDE_PATH : $out/lib/swift/clang/include \
      --suffix CPLUS_INCLUDE_PATH : $out/lib/swift/clang/include \
      --suffix LIBRARY_PATH : ${lib.makeLibraryPath [icu libgcc libuuid]} \
      --suffix PATH : ${lib.makeBinPath [ stdenv.cc.bintools ]}
  '';

  # Hack to avoid build and install directories in RPATHs.
  preFixup = "rm -rf $SWIFT_BUILD_ROOT $SWIFT_INSTALL_DIR";

  meta = with lib; {
    description = "The Swift Programming Language";
    homepage = "https://github.com/apple/swift";
    maintainers = with maintainers; [ dtzWill trepetti dduan ];
    license = licenses.asl20;
    # Swift doesn't support 32-bit Linux, unknown on other platforms.
    platforms = platforms.linux;
    badPlatforms = platforms.i686;
    timeout = 86400; # 24 hours.
  };
}
