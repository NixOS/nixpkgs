{ stdenv, fetchurl, flex, bison, ncurses, buddy, tecla, libsigsegv, gmpxx, makeWrapper }:

stdenv.mkDerivation rec {
  name = "maude-2.6";

  src = fetchurl {
    url = "http://maude.cs.uiuc.edu/download/current/Maude-2.6.tar.gz";
    sha256 = "182abzhvjvlaa21aqv7802v3bs57a4dm7cw09s3mqmih7nzpkfm5";
  };

  fullMaude = fetchurl {
    url = "https://full-maude.googlecode.com/git/full-maude261h.maude";
    sha256 = "0xx8bfn6arsa75m5vhp5lmpazgfw230ssq33h9vifswlvzzc81ha";
  };

  buildInputs = [flex bison ncurses buddy tecla gmpxx libsigsegv makeWrapper];

  preConfigure = ''
    configureFlagsArray=(
      --datadir=$out/share/maude
      TECLA_LIBS="-ltecla -lncursesw"
      CFLAGS="-O3" CXXFLAGS="-O3"
    )
  '';

  doCheck = true;

  postInstall = ''
    for n in "$out/bin/"*; do wrapProgram "$n" --suffix MAUDE_LIB ':' "$out/share/maude"; done
    mkdir -p $out/share/maude
    cp ${fullMaude} -d $out/share/maude/full-maude.maude
  '';

  meta = {
    homepage = "http://maude.cs.uiuc.edu/";
    description = "Maude -- a high-level specification language";
    license = "GPLv2";

    longDescription = ''
      Maude is a high-performance reflective language and system
      supporting both equational and rewriting logic specification and
      programming for a wide range of applications. Maude has been
      influenced in important ways by the OBJ3 language, which can be
      regarded as an equational logic sublanguage. Besides supporting
      equational specification and programming, Maude also supports
      rewriting logic computation.
    '';

    hydraPlatforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
