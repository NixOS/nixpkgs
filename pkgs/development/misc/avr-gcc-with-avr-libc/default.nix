{ stdenv, fetchurl, texinfo, gmp, mpfr, libmpc, zlib }:

stdenv.mkDerivation {
  name = "avr-gcc-libc";

  srcs = [
    (fetchurl {
        url = "mirror://gnu/binutils/binutils-2.26.tar.bz2";
        sha256 = "1ngc2h3knhiw8s22l8y6afycfaxr5grviqy7mwvm4bsl14cf9b62";
    })

    (fetchurl {
          url = "mirror://gcc/releases/gcc-5.3.0/gcc-5.3.0.tar.bz2";
          sha256 = "1ny4smkp5bzs3cp8ss7pl6lk8yss0d9m4av1mvdp72r1x695akxq";
    })

    (fetchurl {
        url = http://download.savannah.gnu.org/releases/avr-libc/avr-libc-2.0.0.tar.bz2;
        sha256 = "15svr2fx8j6prql2il2fc0ppwlv50rpmyckaxx38d3gxxv97zpdj";
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
    platforms = platforms.linux;
  };
}
