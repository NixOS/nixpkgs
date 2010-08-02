{ stdenv, fetchurl, writeTextFile, coreutils, gnumake, gcc, gnutar, bzip2, gnugrep, gnused, gawk }:

stdenv.mkDerivation {
  name = "avr-gcc-libc";

  srcBinutils = fetchurl {
    url = ftp://ftp.gnu.org/gnu/binutils/binutils-2.17.tar.bz2;
    sha256 = "0pm20n2l9ddgdpgzk3zhnbb8nbyb4rb2kvcw21pkd6iwybk3rhz2";
  };

  srcGCC = fetchurl {
    url = ftp://ftp.gnu.org/gnu/gcc/gcc-4.1.2/gcc-core-4.1.2.tar.bz2;
    sha256 = "07binc1hqlr0g387zrg5sp57i12yzd5ja2lgjb83bbh0h3gwbsbv";
  };

  srcAVRLibc = fetchurl {
    url = http://www.very-clever.com/download/nongnu/avr-libc/avr-libc-1.4.5.tar.bz2;
    sha256 = "058iv3vs6syy01pfkd5894xap9zakjx8ki1bpjdnihn6vk6fr80l";
  };

  phases = "doAll";

  # don't call any wired $buildInputs/nix-support/* scripts or such. This makes the build fail 
  builder = writeTextFile {
    name = "avrbinutilsgccavrlibc-builder-script";
    text =  ''
    PATH=${coreutils}/bin:${gnumake}/bin:${gcc}/bin:${gnutar}/bin:${bzip2}/bin:${gnugrep}/bin:${gnused}/bin:${gawk}/bin
    # that's all a bit too hacky...!
    for i in `cat ${gcc}/nix-support/propagated-user-env-packages`; do
      echo adding $i
      PATH=$PATH:$i/bin
    done
    mkdir -p "$out"
    export > env-vars

    # important, without this gcc won't find the binutils executables
    PATH=$PATH:$out/bin

    prefix=$out

    tar jxf $srcBinutils
      cd binutils-*/
      mkdir obj-avr
      cd obj-avr
      ../configure --target=avr --prefix="$prefix" --disable-nls --prefix=$prefix
      make $MAKE_FLAGS
      make install

    cd $TMP
    tar jxf $srcGCC
      cd gcc-*
      mkdir obj-avr
      cd obj-avr
      ../configure --target=avr --prefix="$prefix" --disable-nls --enable-languages=c --disable-libssp
      make $MAKE_FLAGS
      make install

    cd $TMP
      tar jxf $srcAVRLibc
      cd avr-libc-*
      ./configure --prefix="$prefix" --build=`./config.guess` --host=avr
      make $MAKE_FLAGS
      make install
    '';
  };

  meta = { 
      description = "avr gcc developement environment including binutils, avr-gcc and avr-libc";
      # I've tried compiling the packages separately.. too much hassle. This just works. Fine.
      license =  ["GPL" "LGPL"]; # see single packages ..
      homepage = []; # dito
  };
}
