{ stdenv
, cmake
, coreutils
, glibc
, which
, perl
, libedit
, ninja
, pkgconfig
, sqlite
, swig
, bash
, libxml2
, clang
, python
, ncurses
, libuuid
, libbsd
, icu
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
  version = "5.1.1";

  fetch = { repo, sha256, fetchSubmodules ? false }:
    fetchFromGitHub {
      owner = "apple";
      inherit repo sha256 fetchSubmodules;
      rev = "swift-${version}-RELEASE";
      name = "${repo}-${version}-src";
    };

  sources = {
    llvm = fetch {
      repo = "swift-llvm";
      sha256 = "00ldd9dby6fl6nk3z17148fvb7g9x4jkn1afx26y51v8rwgm1i7f";
    };
    compilerrt = fetch {
      repo = "swift-compiler-rt";
      sha256 = "1431f74l0n2dxn728qp65nc6hivx88fax1wzfrnrv19y77br05wj";
    };
    clang = fetch {
      repo = "swift-clang";
      sha256 = "0n7k6nvzgqp6h6bfqcmna484w90db3zv4sh5rdh89wxyhdz6rk4v";
    };
    clangtools = fetch {
      repo = "swift-clang-tools-extra";
      sha256 = "0snp2rpd60z239pr7fxpkj332rkdjhg63adqvqdkjsbrxcqqcgqa";
    };
    indexstore = fetch {
      repo = "indexstore-db";
      sha256 = "1gwkqkdmpd5hn7555dpdkys0z50yh00hjry2886h6rx7avh5p05n";
    };
    sourcekit = fetch {
      repo = "sourcekit-lsp";
      sha256 = "0k84ssr1k7grbvpk81rr21ii8csnixn9dp0cga98h6i1gshn8ml4";
    };
    cmark = fetch {
      repo = "swift-cmark";
      sha256 = "079smm79hbwr06bvghd2sb86b8gpkprnzlyj9kh95jy38xhlhdnj";
    };
    lldb = fetch {
      repo = "swift-lldb";
      sha256 = "0j787475f0nlmvxqblkhn3yrvn9qhcb2jcijwijxwq95ar2jdygs";
    };
    llbuild = fetch {
      repo = "swift-llbuild";
      sha256 = "1n2s5isxyl6b6ya617gdzjbw68shbvd52vsfqc1256rk4g448v8b";
    };
    pm = fetch {
      repo = "swift-package-manager";
      sha256 = "1a49jmag5mpld9zr96g8a773334mrz1c4nyw38gf4p6sckf4jp29";
    };
    xctest = fetch {
      repo = "swift-corelibs-xctest";
      sha256 = "0rxy9sq7i0s0kxfkz0hvdp8zyb40h31f7g4m0kry36qk82gzzh89";
    };
    foundation = fetch {
      repo = "swift-corelibs-foundation";
      sha256 = "1iiiijsnys0r3hjcj1jlkn3yszzi7hwb2041cnm5z306nl9sybzp";
    };
    libdispatch = fetch {
      repo = "swift-corelibs-libdispatch";
      sha256 = "0laqsizsikyjhrzn0rghvxd8afg4yav7cbghvnf7ywk9wc6kpkmn";
      fetchSubmodules = true;
    };
    swift = fetch {
      repo = "swift";
      sha256 = "0m4r1gzrnn0s1c7haqq9dlmvpqxbgbkbdfmq6qaph869wcmvdkvy";
    };
  };

  devInputs = [
    curl
    glibc
    icu
    libblocksruntime
    libbsd
    libedit
    libuuid
    libxml2
    ncurses
    sqlite
    swig
  ];

  cmakeFlags = [
    "-DGLIBC_INCLUDE_PATH=${stdenv.cc.libc.dev}/include"
    "-DC_INCLUDE_DIRS=${stdenv.lib.makeSearchPathOutput "dev" "include" devInputs}:${libxml2.dev}/include/libxml2"
    "-DGCC_INSTALL_PREFIX=${clang.cc.gcc}"
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
    gnumake
    libtool
    makeWrapper
    ninja
    perl
    pkgconfig
    python
    rsync
    which
  ];
  buildInputs = devInputs ++ [
    clang
  ];

  # TODO: Revisit what's propagated and how
  propagatedBuildInputs = [
    libgit2
    python
  ];
  propagatedUserEnvPkgs = [ git pkgconfig ];

  hardeningDisable = [ "format" ]; # for LLDB

  unpackPhase = ''
    mkdir src
    cd src
    export SWIFT_SOURCE_ROOT=$PWD

    cp -r ${sources.llvm} llvm
    cp -r ${sources.compilerrt} compiler-rt
    cp -r ${sources.clang} clang
    cp -r ${sources.clangtools} clang-tools-extra
    cp -r ${sources.indexstore} indexstore-db
    cp -r ${sources.sourcekit} sourcekit-lsp
    cp -r ${sources.cmark} cmark
    cp -r ${sources.lldb} lldb
    cp -r ${sources.llbuild} llbuild
    cp -r ${sources.pm} swiftpm
    cp -r ${sources.xctest} swift-corelibs-xctest
    cp -r ${sources.foundation} swift-corelibs-foundation
    cp -r ${sources.libdispatch} swift-corelibs-libdispatch
    cp -r ${sources.swift} swift

    chmod -R u+w .
  '';

  patchPhase = ''
    # Just patch all the things for now, we can focus this later
    patchShebangs $SWIFT_SOURCE_ROOT

    # TODO eliminate use of env.
    find -type f -print0 | xargs -0 sed -i \
      -e 's|/usr/bin/env|${coreutils}/bin/env|g' \
      -e 's|/usr/bin/make|${gnumake}/bin/make|g' \
      -e 's|/bin/mkdir|${coreutils}/bin/mkdir|g' \
      -e 's|/bin/cp|${coreutils}/bin/cp|g' \
      -e 's|/usr/bin/file|${file}/bin/file|g'

    substituteInPlace swift/stdlib/public/Platform/CMakeLists.txt \
      --replace '/usr/include' "${stdenv.cc.libc.dev}/include"
    substituteInPlace swift/utils/build-script-impl \
      --replace '/usr/include/c++' "${clang.cc.gcc}/include/c++"
    patch -p1 -d swift -i ${./patches/glibc-arch-headers.patch}
    patch -p1 -d swift -i ${./patches/0001-build-presets-linux-don-t-require-using-Ninja.patch}
    patch -p1 -d swift -i ${./patches/0002-build-presets-linux-allow-custom-install-prefix.patch}
    patch -p1 -d swift -i ${./patches/0003-build-presets-linux-don-t-build-extra-libs.patch}
    patch -p1 -d swift -i ${./patches/0004-build-presets-linux-plumb-extra-cmake-options.patch}

    sed -i swift/utils/build-presets.ini \
      -e 's/^test-installable-package$/# \0/' \
      -e 's/^test$/# \0/' \
      -e 's/^validation-test$/# \0/' \
      -e 's/^long-test$/# \0/' \
      -e 's/^stress-test$/# \0/' \
      -e 's/^test-optimized$/# \0/' \
      \
      -e 's/^swift-install-components=autolink.*$/\0;editor-integration/'

    substituteInPlace clang/lib/Driver/ToolChains/Linux.cpp \
      --replace 'SysRoot + "/lib' '"${glibc}/lib" "'
    substituteInPlace clang/lib/Driver/ToolChains/Linux.cpp \
      --replace 'SysRoot + "/usr/lib' '"${glibc}/lib" "'
    patch -p1 -d clang -i ${./patches/llvm-toolchain-dir.patch}
    patch -p1 -d clang -i ${./purity.patch}

    # Workaround hardcoded dep on "libcurses" (vs "libncurses"):
    sed -i 's/curses/ncurses/' llbuild/*/*/CMakeLists.txt
    # uuid.h is not part of glibc, but of libuuid
    sed -i 's|''${GLIBC_INCLUDE_PATH}/uuid/uuid.h|${libuuid.dev}/include/uuid/uuid.h|' swift/stdlib/public/Platform/glibc.modulemap.gyb

    # Compatibility with glibc 2.30
    # Adapted from https://github.com/apple/swift-package-manager/pull/2408
    patch -p1 -d swiftpm -i ${./patches/swift-package-manager-glibc-2.30.patch}
    # https://github.com/apple/swift/pull/27288
    patch -p1 -d swift -i ${fetchpatch {
      url = "https://github.com/apple/swift/commit/f968f4282d53f487b29cf456415df46f9adf8748.patch";
      sha256 = "1aa7l66wlgip63i4r0zvi9072392bnj03s4cn12p706hbpq0k37c";
    }}

    PREFIX=''${out/#\/}
    substituteInPlace indexstore-db/Utilities/build-script-helper.py \
      --replace usr "$PREFIX"
    substituteInPlace sourcekit-lsp/Utilities/build-script-helper.py \
      --replace usr "$PREFIX"
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
    # gcc-6.4.0/include/c++/6.4.0/cstdlib:75:15: fatal error: 'stdlib.h' file not found
    export NIX_CFLAGS_COMPILE="$( echo ${clang.default_cxx_stdlib_compile} ) $NIX_CFLAGS_COMPILE"
    # During the Swift build, a full local LLVM build is performed and the resulting clang is invoked.
    # This compiler is not using the Nix wrappers, so it needs some help to find things.
    export NIX_LDFLAGS_BEFORE="-rpath ${clang.cc.gcc.lib}/lib -L${clang.cc.gcc.lib}/lib $NIX_LDFLAGS_BEFORE"
    # However, we want to use the wrapped compiler whenever possible.
    export CC="${clang}/bin/clang"

    # fix for https://bugs.llvm.org/show_bug.cgi?id=39743
    # see also https://forums.swift.org/t/18138/15
    export CCC_OVERRIDE_OPTIONS="#x-fmodules s/-fmodules-cache-path.*//"

    $SWIFT_SOURCE_ROOT/swift/utils/build-script \
      --preset=buildbot_linux \
      installable_package=$INSTALLABLE_PACKAGE \
      install_prefix=$out \
      install_destdir=$SWIFT_INSTALL_DIR \
      extra_cmake_options="${stdenv.lib.concatStringsSep "," cmakeFlags}"
  '';

  doCheck = true;

  checkInputs = [ file ];

  checkPhase = ''
    # FIXME: disable non-working tests
    rm $SWIFT_SOURCE_ROOT/swift/test/Driver/static-stdlib-linux.swift  # static linkage of libatomic.a complains about missing PIC
    rm $SWIFT_SOURCE_ROOT/swift/validation-test/Python/build_swift.swift  # install_prefix not passed properly

    # match the swift wrapper in the install phase
    export LIBRARY_PATH=${icu}/lib:${libuuid.out}/lib

    checkTarget=check-swift-all
    ninjaFlags='-C buildbot_linux/swift-${stdenv.hostPlatform.parsed.kernel.name}-${stdenv.hostPlatform.parsed.cpu.name}'
    ninjaCheckPhase
  '';

  installPhase = ''
    mkdir -p $out

    # Extract the generated tarball into the store
    tar xf $INSTALLABLE_PACKAGE -C $out --strip-components=3 ''${out/#\/}
    find $out -type d -empty -delete

    # fix installation weirdness, also present in Apple’s official tarballs
    mv $out/local/include/indexstore $out/include
    rmdir $out/local/include $out/local
    rm -r $out/bin/sdk-module-lists $out/bin/swift-api-checker.py

    wrapProgram $out/bin/swift \
      --suffix C_INCLUDE_PATH : $out/lib/swift/clang/include \
      --suffix CPLUS_INCLUDE_PATH : $out/lib/swift/clang/include \
      --suffix LIBRARY_PATH : ${icu}/lib:${libuuid.out}/lib
  '';

  # Hack to avoid build and install directories in RPATHs.
  preFixup = ''rm -rf $SWIFT_BUILD_ROOT $SWIFT_INSTALL_DIR'';

  meta = with stdenv.lib; {
    description = "The Swift Programming Language";
    homepage = https://github.com/apple/swift;
    maintainers = with maintainers; [ dtzWill ];
    license = licenses.asl20;
    # Swift doesn't support 32bit Linux, unknown on other platforms.
    platforms = platforms.linux;
    badPlatforms = platforms.i686;
    broken = stdenv.isAarch64; # 2018-09-04, never built on Hydra
  };
}
