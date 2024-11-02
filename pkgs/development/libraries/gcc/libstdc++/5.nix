{ lib, stdenv, fetchurl, fetchpatch, flex, bison, file }:

stdenv.mkDerivation rec {
  pname = "libstdc++5";
  version = "3.3.6";

  src = [
    (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-core-${version}.tar.bz2";
      sha256 = "1dpyrpsgakilz2rnh5f8gvrzq5pwzvndacc0df6m04bpqn5fx6sg";
    })
    (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-g++-${version}.tar.bz2";
      sha256 = "14lxl81f7adpc9jxfiwzdxsdzs5zv4piv8xh7f9w910hfzrgvsby";
    })
  ];

  patches = [
    ./no-sys-dirs.patch
    (fetchpatch {
      name = "siginfo.patch";
      url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/e36ee8ed9bb5942db14cf6249a2ead14974a2bfa/trunk/siginfo.patch";
      sha256 = "15zldbm33yba293dgrgsbv3j332hkc3iqpyc8fa7zl42mh9qk22j";
      extraPrefix = "";
    })
    (fetchpatch {
      name = "gcc-3.4.3-no_multilib_amd64.patch";
      url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/e36ee8ed9bb5942db14cf6249a2ead14974a2bfa/trunk/gcc-3.4.3-no_multilib_amd64.patch";
      sha256 = "11m5lc51b0addhc4yq4rz0dwpv6k73rrj73wya3lqdk8rly6cjpm";
      extraPrefix = "";
    })
    # Required because of glibc 2.26
    ./struct-ucontext.patch
  ];

  postPatch = ''
    # fix build issue with recent gcc
    sed -i "s#O_CREAT#O_CREAT, 0666#" gcc/collect2.c

    # No fixincludes
    sed -i -e 's@\./fixinc\.sh@-c true@' gcc/Makefile.in
  '';

  preConfigure = ''
    mkdir ../build
    cd ../build
    configureScript=../$sourceRoot/configure
  '';

  preBuild = ''
    # libstdc++ needs this; otherwise it will use /lib/cpp, which is a Bad
    # Thing.
    export CPP="gcc -E"

    # Use *real* header files, otherwise a limits.h is generated
    # that does not include Glibc's limits.h (notably missing
    # SSIZE_MAX, which breaks the build).
    export NIX_FIXINC_DUMMY="$(cat $NIX_CC/nix-support/orig-libc-dev)/include"

    # The path to the Glibc binaries such as `crti.o'.
    glibc_libdir="$(cat $NIX_CC/nix-support/orig-libc)/lib"

    # Figure out what extra flags to pass to the gcc compilers
    # being generated to make sure that they use our glibc.
    EXTRA_FLAGS="-I$NIX_FIXINC_DUMMY $(cat $NIX_CC/nix-support/libc-crt1-cflags) $(cat $NIX_CC/nix-support/libc-cflags) -O2"

    extraLDFlags="-L$glibc_libdir -rpath $glibc_libdir $(cat $NIX_BINTOOLS/nix-support/libc-ldflags || true) $(cat $NIX_BINTOOLS/nix-support/libc-ldflags-before || true)"
    for i in $extraLDFlags; do
      EXTRA_FLAGS="$EXTRA_FLAGS -Wl,$i"
    done

    # CFLAGS_FOR_TARGET are needed for the libstdc++ configure script to find
    # the startfiles.
    # FLAGS_FOR_TARGET are needed for the target libraries to receive the -Bxxx
    # for the startfiles.
    makeFlagsArray=( \
      "''${makeFlagsArray[@]}" \
      NATIVE_SYSTEM_HEADER_DIR="$NIX_FIXINC_DUMMY" \
      SYSTEM_HEADER_DIR="$NIX_FIXINC_DUMMY" \
      CFLAGS_FOR_BUILD="$EXTRA_FLAGS" \
      CFLAGS_FOR_TARGET="$EXTRA_FLAGS" \
      CXXFLAGS_FOR_BUILD="$EXTRA_FLAGS" \
      CXXFLAGS_FOR_TARGET="$EXTRA_FLAGS" \
      FLAGS_FOR_TARGET="$EXTRA_FLAGS" \
      LDFLAGS_FOR_BUILD="$EXTRA_FLAGS" \
      LDFLAGS_FOR_TARGET="$EXTRA_FLAGS" \
      BOOT_CFLAGS="$EXTRA_FLAGS" \
      BOOT_LDFLAGS="$EXTRA_FLAGS"
      )
  '';

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ flex bison file ];

  configureFlags = [ "--disable-multilib" "--enable-__cxa-atexit" "--enable-threads=posix" "--enable-languages=c++" "--enable-clocale=gnu" ];

  buildFLags = [ "all-target-libstdc++-v3" ];

  installFlags = [ "install-target-libstdc++-v3" ];

  postInstall = ''
    # Remove includefiles and libs provided by gcc
    shopt -s extglob
    rm -rf $out/{bin,include,share,man,info}
    rm -f $out/lib/*.a
    rm -rf $out/lib/!(libstdc++*)
  '';

  meta = with lib; {
    homepage = "https://gcc.gnu.org/";
    license = licenses.lgpl3Plus;
    description = "GNU Compiler Collection, version ${version} -- C++ standard library";
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
  };
}
