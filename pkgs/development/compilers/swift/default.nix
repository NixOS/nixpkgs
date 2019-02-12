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
, findutils
, makeWrapper
, gnumake
, file
}:

let
  v_base = "4.2.2";
  version = "${v_base}-RELEASE";
  version_friendly = "${v_base}";

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
      sha256 = "0l6w4xzpl3w2nax9a0b885nfzhfj38p2g99158nb5bzfd4s0man7";
    };
    llvm = fetch {
      repo = "swift-llvm";
      sha256 = "1664zwxbq0a1cmxr9n5a0vw6vdk6ygr7rpglpdsfc7ki857vpsyv";
    };
    compilerrt = fetch {
      repo = "swift-compiler-rt";
      sha256 = "19s6qxn4i0kxpf39xjp2i7zg427iinbmaxqkbb1p91g616y367sf";
    };
    cmark = fetch {
      repo = "swift-cmark";
      sha256 = "1nmxp0fj749sgar682c5nsj7zxxigqwg973baxj2r656a7ybh325";
    };
    lldb = fetch {
      repo = "swift-lldb";
      sha256 = "00kz0xhj1p6ckyandj2gs1yfl29kxv84x9pfph00r8crbkd2jz7b";
    };
    llbuild = fetch {
      repo = "swift-llbuild";
      sha256 = "1mkkhydshhxr28igbldzr0hhqvb6ql43cpf3ba5vglfkbcz6wh6q";
    };
    pm = fetch {
      repo = "swift-package-manager";
      sha256 = "1aqvmgq9g5zs4k2qnkvw3h3mar66d690hqq6g2dmrapsyb321j9l";
    };
    xctest = fetch {
      repo = "swift-corelibs-xctest";
      sha256 = "1n4w7bfgy73vjzbvbphlwayy0dw73bbrayrpkqq8lbidg0x9lam8";
    };
    foundation = fetch {
      repo = "swift-corelibs-foundation";
      sha256 = "1ki9vc723r13zgm6bcmif43aypavb2hz299gbhp93qkndz8hqkx5";
    };
    libdispatch = fetch {
      repo = "swift-corelibs-libdispatch";
      sha256 = "0fibrx54nbaawhsgd7cbr356ji9qvf8y8ahd5bdx28fpj6q0cnwc";
      fetchSubmodules = true;
    };
    swift = fetch {
      repo = "swift";
      sha256 = "1hwi6hi9ss1kj1s65v5q8v8d872c0914qfy1018xijd029lwq694";
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

  builder = ''
    # gcc-6.4.0/include/c++/6.4.0/cstdlib:75:15: fatal error: 'stdlib.h' file not found
    NIX_CFLAGS_COMPILE="$( echo ${clang.default_cxx_stdlib_compile} ) $NIX_CFLAGS_COMPILE"

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
    makeWrapper
    gnumake
  ];

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
    substituteInPlace swift-corelibs-libdispatch/src/CMakeLists.txt \
      --replace '/usr/include' "${stdenv.cc.libc.dev}/include"
    substituteInPlace swift/utils/build-script-impl \
      --replace '/usr/include/c++' "${clang.cc.gcc}/include/c++"
    patch -p1 -d swift -i ${./patches/glibc-arch-headers.patch}
    patch -p1 -d swift -i ${./patches/0001-build-presets-linux-don-t-require-using-Ninja.patch}
    patch -p1 -d swift -i ${./patches/0002-build-presets-linux-allow-custom-install-prefix.patch}
    patch -p1 -d swift -i ${./patches/0004-build-presets-linux-plumb-extra-cmake-options.patch}

    sed -i swift/utils/build-presets.ini \
      -e 's/^test-installable-package$/# \0/' \
      -e 's/^test$/# \0/' \
      -e 's/^validation-test$/# \0/' \
      -e 's/^long-test$/# \0/' \
      -e 's/^stress-test$/# \0/' \
      -e 's/^test-optimized$/# \0/'

    # https://bugs.swift.org/browse/SR-5779
    sed -i -e 's|"-latomic"|"-Wl,-rpath,${clang.cc.gcc.lib}/lib" "-L${clang.cc.gcc.lib}/lib" "-latomic"|' swift/cmake/modules/AddSwift.cmake

    substituteInPlace clang/lib/Driver/ToolChains/Linux.cpp \
      --replace 'SysRoot + "/usr/lib' '"${glibc}/lib" "'
    patch -p1 -d clang -i ${./patches/llvm-include-dirs.patch}
    patch -p1 -d clang -i ${./purity.patch}

    # Workaround hardcoded dep on "libcurses" (vs "libncurses"):
    sed -i 's,curses,ncurses,' llbuild/*/*/CMakeLists.txt

    PREFIX=''${out/#\/}
    substituteInPlace swift-corelibs-foundation/build.py \
      --replace usr/lib "$PREFIX/lib"
    substituteInPlace swift-corelibs-xctest/build_script.py \
      --replace usr "$PREFIX"
    substituteInPlace swiftpm/Utilities/bootstrap \
      --replace \"usr\" \"$PREFIX\" \
      --replace usr/lib "$PREFIX/lib"
  '';

  doCheck = false;

  buildPhase = builder;

  installPhase = ''
    mkdir -p $out

    # Extract the generated tarball into the store
    PREFIX=''${out/#\/}
    tar xf $INSTALLABLE_PACKAGE -C $out --strip-components=3 $PREFIX
    find $out -type d -empty -delete

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
    platforms = platforms.linux;
    badPlatforms = platforms.i686;
    broken = stdenv.isAarch64; # 2018-09-04, never built on Hydra
  };
}
