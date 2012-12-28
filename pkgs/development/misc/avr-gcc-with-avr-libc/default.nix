{ stdenv, fetchurl, writeTextFile, coreutils, gnumake, gcc, gnutar, bzip2
  , gnugrep, gnused, gawk, diffutils, patch
  , gmp, mpfr, mpc }:

stdenv.mkDerivation {
  name = "avr-gcc-libc";

  srcBinutils = fetchurl {
    url = "mirror://gnu/binutils/binutils-2.21.1.tar.bz2";
    sha256 = "0m7nmd7gc9d9md43wbrv65hz6lbi2crqwryzpigv19ray1lzmv6d";
  };

  srcGCC = fetchurl {
    url = "mirror://gcc/releases/gcc-4.6.3/gcc-core-4.6.3.tar.bz2";
    sha256 = "1hai090f0svf886nyhn4glmfw54v9lz88w2izkx5iqhd3j400gi8";
  };

  srcGCCGPP = fetchurl {
    url = "mirror://gcc/releases/gcc-4.6.3/gcc-g++-4.6.3.tar.bz2";
    sha256 = "1s199gb6p65r5k69cdfqqcz5hgifw9bhyj65n2b91s80x4rwgq5k";
  };

  srcAVRLibc = fetchurl {
    url = http://download.savannah.gnu.org/releases/avr-libc/avr-libc-1.7.1.tar.bz2;
    sha256 = "1b1s4cf787izlm3r094vvkzrzb3w3bg6bwiz2wz71cg7q07kzzn6";
  };

  phases = "doAll";

  # don't call any wired $buildInputs/nix-support/* scripts or such. This makes the build fail 
  builder = writeTextFile {
    name = "avrbinutilsgccavrlibc-builder-script";
    text =  ''
    PATH=${coreutils}/bin:${gnumake}/bin:${gcc}/bin:${gnutar}/bin:${bzip2}/bin:${gnugrep}/bin:${gnused}/bin:${gawk}/bin:${diffutils}/bin:${patch}/bin
    # that's all a bit too hacky...!
    for i in `cat ${gcc}/nix-support/propagated-user-env-packages`; do
      echo adding $i
      PATH=$PATH:$i/bin
    done
    mkdir -p "$out"
    export > env-vars

    for i in "${gmp}" "${mpfr}" "${mpc}"; do
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$i/include "
      export NIX_LDFLAGS="$NIX_LDFLAGS -L$i/lib "
    done

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
    tar jxf $srcGCCGPP
      cd gcc-*
      mkdir obj-avr
      cd obj-avr
      ../configure --target=avr --prefix="$prefix" --disable-nls --enable-languages=c,c++ --disable-libssp --with-dwarf2
      make $MAKE_FLAGS
      make install

    cd $TMP
      tar jxf $srcAVRLibc
      cd avr-libc-*
      patch -Np1 -i ${./avr-libc-fix-gcc-4.6.0.patch}
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
