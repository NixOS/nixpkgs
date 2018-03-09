{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "picat-2.3";

  src = fetchurl {
    url = http://picat-lang.org/download/picat19_src.tar.gz;
    sha256 = "1l5vzsscpp6nds6ksn57vjkkpzznl5xh7x6idjfn7pyh8jjhp50g";
  };

  ARCH = if stdenv.system == "i686-linux" then "linux32"
         else if stdenv.system == "x86_64-linux" then "linux64"
         else throw "Unsupported system";

  hardeningDisable = [ "format" ];

  buildPhase = ''
    cd emu
    make -f Makefile.picat.$ARCH
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp picat_$ARCH $out/bin/picat
  '';

  meta = {
    description = "Logic-based programming langage";
    longDescription = ''
      Picat is a simple, and yet powerful, logic-based multi-paradigm
      programming language aimed for general-purpose applications.
    '';
    homepage = http://picat-lang.org/;
    license = stdenv.lib.licenses.mpl20;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.earldouglas ];
  };
}
