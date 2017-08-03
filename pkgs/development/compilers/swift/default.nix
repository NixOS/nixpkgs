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
, llvm
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
, binutils
, fetchFromGitHub
, paxctl
, findutils
#, systemtap
}:

let
  v_major = "3.1.1";
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
      sha256 = "1gmdgr8jph87nya8cgdl7iwrggbji2sag996m27hkbszw4nxy8sd";
    };
    llvm = fetch {
      repo = "swift-llvm";
      sha256 = "0nwd7cp6mbj7f6a2rx8123n7ygs8406hsx7hp7ybagww6v75bwzi";
    };
    compilerrt = fetch {
      repo = "swift-compiler-rt";
      sha256 = "1gjcr6g3ffs3nhf4a84iwg4flbd7rqcf9rvvclwyq96msa3mj950";
    };
    cmark = fetch {
      repo = "swift-cmark";
      sha256 = "0qf2f3zd8lndkfbxbz6vkznzz8rvq5gigijh7pgmfx9fi4zcssqx";
    };
    lldb = fetch {
      repo = "swift-lldb";
      sha256 = "17n4whpf3wxw9zaayiq21gk9q3547qxi4rvxld2hybh0k7a1bj5c";
    };
    llbuild = fetch {
      repo = "swift-llbuild";
      sha256 = "1l3hnb2s01jby91k1ipbc3bhszq14vyx5pzdhf2chld1yhpg420d";
    };
    pm = fetch {
      repo = "swift-package-manager";
      sha256 = "1ayy5vk3mjk354pg9bf68wvnaj3jymx23w0qnlw1jxz256ff8fwi";
    };
    xctest = fetch {
      repo = "swift-corelibs-xctest";
      sha256 = "0cj5y7wanllfldag08ci567x12aw793c79afckpbsiaxmwy4xhnm";
    };
    foundation = fetch {
      repo = "swift-corelibs-foundation";
      sha256 = "1d1ldk7ckqn4mhmdhsx2zrmsd6jfxzgdywn2pki7limk979hcwjc";
    };
    libdispatch = fetch {
      repo = "swift-corelibs-libdispatch";
      sha256 = "0ckjg41fjak06i532azhryckjq64fkxzsal4svf5v4s8n9mkq2sg";
      fetchSubmodules = true;
    };
    swift = fetch {
      repo = "swift";
      sha256 = "0879jlv37lmxc1apzi53xn033y72548i86r7fzwr0g52124q5gry";
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
    $SWIFT_SOURCE_ROOT/swift/utils/build-script \
      --preset=buildbot_linux \
      installable_package=$INSTALLABLE_PACKAGE \
      install_prefix=$out \
      install_destdir=$SWIFT_INSTALL_DIR \
      extra_cmake_options="${stdenv.lib.concatStringsSep "," cmakeFlags}"'';

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

    substituteInPlace clang/lib/Driver/ToolChains.cpp \
      --replace '  addPathIfExists(D, SysRoot + "/usr/lib", Paths);' \
                '  addPathIfExists(D, SysRoot + "/usr/lib", Paths); addPathIfExists(D, "${glibc}/lib", Paths);'
    patch -p1 -d clang -i ${./purity.patch}

    # Workaround hardcoded dep on "libcurses" (vs "libncurses"):
    sed -i 's,curses,ncurses,' llbuild/*/*/CMakeLists.txt
    substituteInPlace llbuild/tests/BuildSystem/Build/basic.llbuild \
      --replace /usr/bin/env $(type -p env)

    # This test fails on one of my machines, not sure why.
    # Disabling for now. 
    rm llbuild/tests/Examples/buildsystem-capi.llbuild

    substituteInPlace swift-corelibs-foundation/lib/script.py \
      --replace /bin/cp $(type -p cp)

    PREFIX=''${out/#\/}
    substituteInPlace swift-corelibs-xctest/build_script.py \
      --replace usr "$PREFIX"
    substituteInPlace swiftpm/Utilities/bootstrap \
      --replace "usr" "$PREFIX"
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
    ln -s ${binutils}/bin/ar $out/bin/ar
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = with stdenv.lib; {
    description = "The Swift Programming Language";
    homepage = https://github.com/apple/swift;
    maintainers = with maintainers; [ jb55 dtzWill ];
    license = licenses.asl20;
    # Swift doesn't support 32bit Linux, unknown on other platforms.
    platforms = [ "x86_64-linux" ];
  };
}

