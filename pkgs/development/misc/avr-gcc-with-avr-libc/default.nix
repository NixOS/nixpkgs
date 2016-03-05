{ stdenv, fetchurl, texinfo, gmp, mpfr, libmpc, zlib }:

stdenv.mkDerivation {
  name = "avr-gcc-libc";

  srcs = [
    (fetchurl {
        url = "mirror://gnu/binutils/binutils-2.25.tar.bz2";
        sha256 = "08r9i26b05zcwb9zxb6zllpfdiiicdfsgbpsjlrjmvx3rxjzrpi2";
    })

    (fetchurl {
        url = "mirror://gcc/releases/gcc-4.8.4/gcc-4.8.4.tar.bz2";
        sha256 = "4a80aa23798b8e9b5793494b8c976b39b8d9aa2e53cd5ed5534aff662a7f8695";
    })

    (fetchurl {
        url = http://download.savannah.gnu.org/releases/avr-libc/avr-libc-1.8.1.tar.bz2;
        sha256 = "0sd9qkvhmk9av4g1f8dsjwc309hf1g0731bhvicnjb3b3d42l1n3";
    })
  ];

  sourceRoot = ".";

  nativeBuildInputs = [ texinfo ];

  buildInputs = [ gmp mpfr libmpc zlib ];

  hardeningDisable = [ "format" ];

  # Make sure we don't strip the libraries in lib/gcc/avr.
  stripDebugList= [ "bin" "avr/bin" "libexec" ];

  installPhase = ''
    # important, without this gcc won't find the binutils executables
    export PATH=$PATH:$out/bin

    # Binutils.
    pushd binutils-*/
    mkdir obj-avr
    cd obj-avr
    ../configure --target=avr --prefix="$out" --disable-nls --disable-debug --disable-dependency-tracking
    make $MAKE_FLAGS
    make install
    popd

    # GCC.
    pushd gcc-*
    mkdir obj-avr
    cd obj-avr
    ../configure --target=avr --prefix="$out" --disable-nls --disable-libssp --with-dwarf2 --disable-install-libiberty --with-system-zlib --enable-languages=c,c++
    make $MAKE_FLAGS
    make install
    popd

    # We don't want avr-libc to use the native compiler.
    export BUILD_CC=$CC
    export BUILD_CXX=$CXX
    unset CC
    unset CXX

    # AVR-libc.
    pushd avr-libc-*
    ./configure --prefix="$out" --build=`./config.guess` --host=avr
    make $MAKE_FLAGS
    make install
    popd
  '';

  meta = with stdenv.lib; {
    description = "AVR development environment including binutils, avr-gcc and avr-libc";
    # I've tried compiling the packages separately.. too much hassle. This just works. Fine.
    license =  ["GPL" "LGPL"]; # see single packages ..
    homepage = []; # dito
    platforms = platforms.linux;
  };
}
