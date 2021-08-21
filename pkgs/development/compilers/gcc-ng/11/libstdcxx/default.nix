{ lib, stdenv
, fetchurl, fetchpatch, flex, bison, file
, gcc_src, version
}:

stdenv.mkDerivation rec {
  pname = "libstdc++";
  inherit version;

  src = gcc_src;

  patches = [
    ../custom-threading-model.patch
  ];

  outputs = [ "out" "dev" ];

  strictDeps = true;

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

    extraLDFlags="-L$glibc_libdir -rpath $glibc_libdir $(cat $NIX_BINTOOLS/nix-support/libc-ldflags) $(cat $NIX_BINTOOLS/nix-support/libc-ldflags-before)"
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
  };
}
