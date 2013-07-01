{ stdenv, fetchsvn, coreutils, gnumake, gcc, gnutar, bzip2
  , gnugrep, gnused, gawk, diffutils, patch
  , gmp, mpfr, mpc, bison, flex, writeTextFile }:

stdenv.mkDerivation rec {
  name = "pic32-gcc";

  version = "v105";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/microchipopen/code/ccompiler4pic32/src/branches/${version}-freeze";
    sha256 = "1vc6f8zdci5qsxk331anr0xkpd2g88nidsxj36dn9qx723s7c1qd";
  };

  envPATH = stdenv.lib.makeSearchPath "bin" [
    coreutils gnumake gnutar bzip2 gnugrep
    gnused gawk diffutils patch bison flex
    gcc
  ];

  builder = writeTextFile {
    name = "pic32-gcc-builder";
    text =  ''
      PATH=$envPATH

      # FIXME: Probably will break if cross-compiling NixOS
      # FIXME: Figure out how to do it in a more saner way
      for i in `cat ${gcc}/nix-support/propagated-user-env-packages` \
               `cat ${bison}/nix-support/propagated-native-build-inputs` ; do
        echo adding $i
        PATH=$PATH:$i/bin
      done

      mkdir -p "$out"
      export > env-vars

      # Following flags were taken from 
      # http://sourceforge.net/p/microchipopen/code/40/tree/ccompiler4pic32/buildscripts/trunk/build.sh
      # buildscript, provided by microchip.
      $src/configure --target=pic32mx --program-prefix=pic32- --enable-languages=c --prefix=$out --libexecdir=$out/pic32mx/bin --disable-nls --disable-tui --disable-gdbtk --disable-shared --enable-static --disable-threads --disable-bootstrap --with-dwarf2 --enable-multilib --enable-sim --without-headers --with-lib-path=: --with-pkgversion="Unsupported community build of C Compiler for PIC32 v1.10b" --with-bugurl="http://www.microchipopen.com"

      make clean all install
    '';
  };

  meta = { 
      license = stdenv.lib.licenses.gpl2;
      platforms = stdenv.lib.platforms.linux;
      maintainers = [ stdenv.lib.maintainers.smironov ];
      description = "pic32mx gcc cross-compiler";
      homepage = ["http://sourceforge.net/p/microchipopen/code/40/tree/ccompiler4pic32/"];
      longDescription = ''
        GCC compiler for pic32, obtained from Microchip Open repositories. It does not
        include pic headers (pic32xxxx.h and others), they may be obtained from the
        proprietary xc32 distribution.
      '';
  };
}

