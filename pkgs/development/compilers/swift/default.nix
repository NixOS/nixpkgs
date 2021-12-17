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
, swig
, bash
, libxml2
, clang_10
, python3
, ncurses
, libuuid
, libbsd
, icu
, libgcc
, autoconf
, libtool
, automake
, libblocksruntime
, curl
, rsync
, git
, libgit2
, fetchFromGitHub
, fetchpatch
, findutils
, makeWrapper
, gnumake
, file
}:

let
  version = "5.4.2";

  # These dependency versions can be found in utils/update_checkout/update-checkout-config.json.
  swiftArgumentParserVersion = "0.3.0";
  yamsVersion = "3.0.1";
  swiftFormatVersion = "0.50400.0";

  fetchSwiftRelease = { repo, sha256, fetchSubmodules ? false }:
    fetchFromGitHub {
      owner = "apple";
      inherit repo sha256 fetchSubmodules;
      rev = "swift-${version}-RELEASE";
      name = "${repo}-${version}-src";
    };

  # Sources based on utils/update_checkout/update_checkout-config.json.
  sources = {
    swift = fetchSwiftRelease {
      repo = "swift";
      sha256 = "0qrkqkwpmk312fi12kwwyihin01qb7sphhdz5c6an8j1rjfd9wbv";
    };
    cmark = fetchSwiftRelease {
      repo = "swift-cmark";
      sha256 = "0340j9x2n40yx61ma2pgqfbn3a9ijrh20iwzd1zxqq87rr76hh3z";
    };
    llbuild = fetchSwiftRelease {
      repo = "swift-llbuild";
      sha256 = "0d7sj5a9b5c1ry2209cpccic5radf9s48sp1lahqzmd1pdx3n7pi";
    };
    argumentParser = fetchFromGitHub {
      owner = "apple";
      repo = "swift-argument-parser";
      rev = swiftArgumentParserVersion;
      sha256 = "15vv7hnffa84142q97dwjcn196p2bg8nfh89d6nnix0i681n1qfd";
      name = "swift-argument-parser-${swiftArgumentParserVersion}";
    };
    driver = fetchSwiftRelease {
      repo = "swift-driver";
      sha256 = "1j08273haqv7786rkwsmw7g103glfwy1d2807490id9lagq3r66z";
    };
    toolsSupportCore = fetchSwiftRelease {
      repo = "swift-tools-support-core";
      sha256 = "07gm28ki4px7xzrplvk9nd1pp5r9nyi87l21i0rcbb3r6wrikxb4";
    };
    swiftpm = fetchSwiftRelease {
      repo = "swift-package-manager";
      sha256 = "05linnzlidxamzl3723zhyrfm24pk2cf1x66a3nk0cxgnajw0vzx";
    };
    syntax = fetchSwiftRelease {
      repo = "swift-syntax";
      sha256 = "1y9agx9bg037xjhkwc28xm28kjyqydgv21s4ijgy5l51yg1g0daj";
    };
    # TODO: possibly re-add stress-tester.
    corelibsXctest = fetchSwiftRelease {
      repo = "swift-corelibs-xctest";
      sha256 = "00c68580yr12yxshl0hxyhp8psm15fls3c7iqp52hignyl4v745r";
    };
    corelibsFoundation = fetchSwiftRelease {
      repo = "swift-corelibs-foundation";
      sha256 = "1jyadm2lm7hhik8n8wacfiffpdwqsgnilwmcw22qris5s2drj499";
    };
    corelibsLibdispatch = fetchSwiftRelease {
      repo = "swift-corelibs-libdispatch";
      sha256 = "1s46c0hrxi42r43ff5f1pq2imb3hs05adfpwfxkilgqyb5svafsp";
      fetchSubmodules = true;
    };
    # TODO: possibly re-add integration-tests.
    # Linux does not support Xcode playgrounds.
    # We provide our own ninja.
    # We provider our own icu.
    yams = fetchFromGitHub {
      owner = "jpsim";
      repo = "Yams";
      rev = yamsVersion;
      sha256 = "13md54y7lalrpynrw1s0w5yw6rrjpw46fml9dsk2m3ph1bnlrqrq";
      name = "Yams-${yamsVersion}";
    };
    # We provide our own CMake.
    indexstoreDb = fetchSwiftRelease {
      repo = "indexstore-db";
      sha256 = "1ap3hiq2jd3cn10d8d674xysq27by878mvq087a80681r8cdivn3";
    };
    sourcekitLsp = fetchSwiftRelease {
      repo = "sourcekit-lsp";
      sha256 = "02m9va0lsn2hnwkmgrbgj452sbyaswwmq14lqvxgnb7gssajv4gc";
    };
    format = fetchFromGitHub {
      owner = "apple";
      repo = "swift-format";
      rev = swiftFormatVersion;
      sha256 = "0skmmggsh31f3rnqcrx43178bc7scrjihibnwn68axagasgbqn4k";
      name = "swift-format-${swiftFormatVersion}-src";
    };
    llvmProject = fetchSwiftRelease {
      repo = "llvm-project";
      sha256 = "166hd9d2i55zj70xjb1qmbblbfyk8hdb2qv974i07j6cvynn30lm";
    };
  };

  devInputs = [
    curl
    glibc
    icu
    libblocksruntime
    libbsd
    libedit
    libgcc
    libuuid
    libxml2
    ncurses
    sqlite
    swig
  ];

  python = (python3.withPackages (ps: [ps.six]));

  cmakeFlags = [
    "-DGLIBC_INCLUDE_PATH=${stdenv.cc.libc.dev}/include"
    "-DC_INCLUDE_DIRS=${lib.makeSearchPathOutput "dev" "include" devInputs}:${libxml2.dev}/include/libxml2"
    "-DGCC_INSTALL_PREFIX=${gccForLibs}"
  ];

in
stdenv.mkDerivation {
  name = "swift-${version}";

  nativeBuildInputs = [
    autoconf
    automake
    bash
    cmake
    coreutils
    findutils
    git
    gnumake
    libtool
    makeWrapper
    ninja
    perl
    pkg-config
    python
    rsync
    which
  ];
  buildInputs = devInputs ++ [
    clang_10
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
    # TODO: possibly re-add stress-tester.
    cp -r ${sources.corelibsXctest} swift-corelibs-xctest
    cp -r ${sources.corelibsFoundation} swift-corelibs-foundation
    cp -r ${sources.corelibsLibdispatch} swift-corelibs-libdispatch
    # TODO: possibly re-add integration-tests.
    cp -r ${sources.yams} yams
    cp -r ${sources.indexstoreDb} indexstore-db
    cp -r ${sources.sourcekitLsp} sourcekit-lsp
    cp -r ${sources.format} swift-format
    cp -r ${sources.llvmProject} llvm-project

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
    patch -p1 -d llvm-project/compiler-rt -i ${../llvm/common/compiler-rt/libsanitizer-no-cyclades-11.patch}
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
    export NIX_CFLAGS_COMPILE="$(< ${clang_10}/nix-support/libcxx-cxxflags) $NIX_CFLAGS_COMPILE"

    # During the Swift build, a full local LLVM build is performed and the resulting clang is
    # invoked. This compiler is not using the Nix wrappers, so it needs some help to find things.
    export NIX_LDFLAGS_BEFORE="-rpath ${gccForLibs.lib}/lib -L${gccForLibs.lib}/lib $NIX_LDFLAGS_BEFORE"

    # However, we want to use the wrapped compiler whenever possible.
    export CC="${clang_10}/bin/clang"

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

    # TODO: consider using stress-tester and integration-test.

    # Match the wrapped version of Swift to be installed.
    export LIBRARY_PATH=${icu}/lib:${libgcc}/lib:${libuuid.out}/lib:$l

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
      --suffix LIBRARY_PATH : ${icu}/lib:${libgcc}/lib:${libuuid.out}/lib

    wrapProgram $out/bin/swiftc \
      --set CC $out/bin/clang \
      --suffix C_INCLUDE_PATH : $out/lib/swift/clang/include \
      --suffix CPLUS_INCLUDE_PATH : $out/lib/swift/clang/include \
      --suffix LIBRARY_PATH : ${icu}/lib:${libgcc}/lib:${libuuid.out}/lib
  '';

  # Hack to avoid build and install directories in RPATHs.
  preFixup = "rm -rf $SWIFT_BUILD_ROOT $SWIFT_INSTALL_DIR";

  meta = with lib; {
    description = "The Swift Programming Language";
    homepage = "https://github.com/apple/swift";
    maintainers = with maintainers; [ dtzWill trepetti ];
    license = licenses.asl20;
    # Swift doesn't support 32-bit Linux, unknown on other platforms.
    platforms = platforms.linux;
    badPlatforms = platforms.i686;
    timeout = 86400; # 24 hours.
  };
}
