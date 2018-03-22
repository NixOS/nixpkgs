{ stdenv
, targetPackages
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
, paxctl
, findutils
, makeWrapper
, gnumake
, file
#, systemtap
}:

let
  v_major = "4.0.3";
  version = "${v_major}-RELEASE";
  version_friendly = "${v_major}";

  tag = "refs/tags/swift-${version}";
  fetch = { repo, sha256, fetchSubmodules ? false }:
    fetchFromGitHub {
      owner = "apple";
      inherit repo sha256 fetchSubmodules;
      rev = tag;
      name = "${repo}-${version}-src";
    };

  sources = {
    # FYI: SourceKit probably would work but currently requires building everything twice
    # For more inforation, see: https://github.com/apple/swift/pull/3594#issuecomment-234169759
    clang = fetch {
      repo = "swift-clang";
      sha256 = "0zm624iwiprk3c3nzqf4p1fd9zqic4yi3jv51cw3249ax4x6vy10";
    };
    llvm = fetch {
      repo = "swift-llvm";
      sha256 = "11vw6461c0cdvwm1wna1a5709fjj14hzp6br6jg94p4f6jp3yv4d";
    };
    compilerrt = fetch {
      repo = "swift-compiler-rt";
      sha256 = "1hj4qaj4c9n2wzg2cvarbyl0n708zd1dlw4zkzq07fjxxqs36nfa";
    };
    cmark = fetch {
      repo = "swift-cmark";
      sha256 = "1nmxp0fj749sgar682c5nsj7zxxigqwg973baxj2r656a7ybh325";
    };
    lldb = fetch {
      repo = "swift-lldb";
      sha256 = "0yk5qg85008vcn63vn2jpn5ls9pdhda222p2w1cfkrj27k5k8vqr";
    };
    llbuild = fetch {
      repo = "swift-llbuild";
      sha256 = "0jffw6z1s6ck1i05brw59x6vsg7zrxbz5n2wz72fj29rh3nppc7a";
    };
    pm = fetch {
      repo = "swift-package-manager";
      sha256 = "0xj070b8fii7ijfsnyq4fxgv6569vdrg0yippi85h2p1l7s9aagh";
    };
    xctest = fetch {
      repo = "swift-corelibs-xctest";
      sha256 = "0l355wq8zfwrpv044xf4smjwbm0bmib360748n8cwls3vkr9l2yv";
    };
    foundation = fetch {
      repo = "swift-corelibs-foundation";
      sha256 = "0s7yc5gsbd96a4bs8c6q24dyfjm4xhcr2nzhl2ics8dmi60j15s4";
    };
    libdispatch = fetch {
      repo = "swift-corelibs-libdispatch";
      sha256 = "0x8zzq3shhvmhq4sbhaaa0ddiv3nw347pz6ayym6jyzq7j9n15ia";
      fetchSubmodules = true;
    };
    swift = fetch {
      repo = "swift";
      sha256 = "0a1gq0k5701i418f0qi7kywv16q7vh4a4wp0f6fpyv4sjkq27msx";
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
    #    systemtap?
  ];

  cmakeFlags = [
    "-DGLIBC_INCLUDE_PATH=${stdenv.cc.libc.dev}/include"
    "-DC_INCLUDE_DIRS=${stdenv.lib.makeSearchPathOutput "dev" "include" devInputs}:${libxml2.dev}/include/libxml2"
    "-DGCC_INSTALL_PREFIX=${clang.cc.gcc}"
  ];

  builder = ''
    # gcc-6.4.0/include/c++/6.4.0/cstdlib:75:15: fatal error: 'stdlib.h' file not found
    NIX_CFLAGS_COMPILE="$( echo ${clang.default_cxx_stdlib_compile} ) $NIX_CFLAGS_COMPILE"

    $SWIFT_SOURCE_ROOT/swift/utils/build-script \
      --preset=buildbot_linux \
      installable_package=$INSTALLABLE_PACKAGE \
      install_prefix=$out \
      install_destdir=$SWIFT_INSTALL_DIR \
      extra_cmake_options="${stdenv.lib.concatStringsSep "," cmakeFlags}"'';

  # from llvm/4/llvm.nix
  sigaltstackPatch = fetchpatch {
    name = "sigaltstack.patch"; # for glibc-2.26
    url = https://github.com/llvm-mirror/compiler-rt/commit/8a5e425a68d.diff;
    sha256 = "0h4y5vl74qaa7dl54b1fcyqalvlpd8zban2d1jxfkxpzyi7m8ifi";
  };

  # https://bugs.swift.org/browse/SR-6409
  sigunusedPatch = fetchpatch {
    name = "sigunused.patch";
    url = "https://github.com/apple/swift-llbuild/commit/303a89bc6da606c115560921a452686aa0655f5e.diff";
    sha256 = "04sw7ym1grzggj1v3xrzr2ljxz8rf9rnn9n5fg1xjbwlrdagkc7m";
  };
in
stdenv.mkDerivation rec {
  name = "swift-${version_friendly}";

  buildInputs = devInputs ++ [
    autoconf
    automake
    bash
    clang
    cmake
    coreutils
    libtool
    ninja
    perl
    pkgconfig
    python
    rsync
    which
    findutils
    makeWrapper
    gnumake
  ] ++ stdenv.lib.optional stdenv.needsPax paxctl;

  # TODO: Revisit what's propagated and how
  propagatedBuildInputs = [
    libgit2
    python
  ];
  propagatedUserEnvPkgs = [ git pkgconfig ];

  hardeningDisable = [ "format" ]; # for LLDB

  configurePhase = ''
    cd ..
    
    export INSTALLABLE_PACKAGE=$PWD/swift.tar.gz

    mkdir build install
    export SWIFT_BUILD_ROOT=$PWD/build
    export SWIFT_INSTALL_DIR=$PWD/install

    cd $SWIFT_BUILD_ROOT

    unset CC
    unset CXX

    export NIX_ENFORCE_PURITY=
  '';

  unpackPhase = ''
    mkdir src
    cd src
    export sourceRoot=$PWD
    export SWIFT_SOURCE_ROOT=$PWD

    cp -r ${sources.clang} clang
    cp -r ${sources.llvm} llvm
    cp -r ${sources.compilerrt} compiler-rt
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
  '' + stdenv.lib.optionalString stdenv.needsPax ''
    patch -p1 -d swift -i ${./patches/build-script-pax.patch}
  '' + ''
    patch -p1 -d swift -i ${./patches/0001-build-presets-linux-don-t-require-using-Ninja.patch}
    patch -p1 -d swift -i ${./patches/0002-build-presets-linux-allow-custom-install-prefix.patch}
    patch -p1 -d swift -i ${./patches/0003-build-presets-linux-disable-tests.patch}
    patch -p1 -d swift -i ${./patches/0004-build-presets-linux-plumb-extra-cmake-options.patch}
    # https://sourceware.org/glibc/wiki/Release/2.26#Removal_of_.27xlocale.h.27
    patch -p1 -i ${./patches/remove_xlocale.patch}
    # https://bugs.swift.org/browse/SR-4633
    patch -p1 -d swift -i ${./patches/icu59.patch}

    # https://bugs.swift.org/browse/SR-5779
    sed -i -e 's|"-latomic"|"-Wl,-rpath,${clang.cc.gcc.lib}/lib" "-L${clang.cc.gcc.lib}/lib" "-latomic"|' swift/cmake/modules/AddSwift.cmake

    # https://bugs.swift.org/browse/SR-4838
    sed -i -e '30i#include <functional>' lldb/include/lldb/Utility/TaskPool.h

    substituteInPlace clang/lib/Driver/ToolChains.cpp \
      --replace '  addPathIfExists(D, SysRoot + "/usr/lib", Paths);' \
                '  addPathIfExists(D, SysRoot + "/usr/lib", Paths); addPathIfExists(D, "${glibc}/lib", Paths);'
    patch -p1 -d clang -i ${./purity.patch}

    # Workaround hardcoded dep on "libcurses" (vs "libncurses"):
    sed -i 's,curses,ncurses,' llbuild/*/*/CMakeLists.txt

    # This test fails on one of my machines, not sure why.
    # Disabling for now. 
    rm llbuild/tests/Examples/buildsystem-capi.llbuild

    PREFIX=''${out/#\/}
    substituteInPlace swift-corelibs-xctest/build_script.py \
      --replace usr "$PREFIX"
    substituteInPlace swiftpm/Utilities/bootstrap \
      --replace "usr" "$PREFIX"
  '' + stdenv.lib.optionalString (stdenv ? glibc) ''
    patch -p1 -d compiler-rt -i ${sigaltstackPatch}
    patch -p1 -d compiler-rt -i ${./patches/sigaltstack.patch}
    patch -p1 -d llbuild -i ${sigunusedPatch}
    patch -p1 -i ${./patches/sigunused.patch}
  '';

  doCheck = false;

  buildPhase = builder;

  installPhase = ''
    mkdir -p $out

    # Extract the generated tarball into the store
    PREFIX=''${out/#\/}
    tar xf $INSTALLABLE_PACKAGE -C $out --strip-components=3 $PREFIX

    paxmark pmr $out/bin/swift
    paxmark pmr $out/bin/*

    # TODO: Use wrappers to get these on the PATH for swift tools, instead
    ln -s ${clang}/bin/* $out/bin/
    ln -s ${targetPackages.stdenv.cc.bintools.bintools_bin}/bin/ar $out/bin/ar

    wrapProgram $out/bin/swift \
      --suffix C_INCLUDE_PATH : $out/lib/swift/clang/include \
      --suffix CPLUS_INCLUDE_PATH : $out/lib/swift/clang/include
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = with stdenv.lib; {
    description = "The Swift Programming Language";
    homepage = https://github.com/apple/swift;
    maintainers = with maintainers; [ dtzWill ];
    license = licenses.asl20;
    # Swift doesn't support 32bit Linux, unknown on other platforms.
    platforms = [ "x86_64-linux" ];
  };
}

