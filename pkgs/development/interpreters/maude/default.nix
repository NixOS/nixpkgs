{ stdenv, fetchurl, flex, bison, ncurses, buddy, tecla, libsigsegv, gmpxx, makeWrapper }:

stdenv.mkDerivation rec {
  name = "maude-2.6";

  src = fetchurl {
    url = "http://maude.cs.uiuc.edu/download/current/Maude-2.6.tar.gz";
    sha256 = "182abzhvjvlaa21aqv7802v3bs57a4dm7cw09s3mqmih7nzpkfm5";
  };

  fullMaude = fetchurl {
    url = "http://maude.cs.uiuc.edu/download/current/FM2.6/full-maude26.maude";
    sha256 = "1382hjwwrsdgd5yjn3ph1b5i1bhrhzvqx0v369bmcjkly9k96v6q";
  };

  buildInputs = [flex bison ncurses buddy tecla gmpxx libsigsegv makeWrapper];

  configurePhase = ''./configure --disable-dependency-tracking --prefix=$out --datadir=$out/share/maude TECLA_LIBS="-ltecla -lncursesw" CFLAGS="-O3" CXXFLAGS="-O3"'';

  doCheck = true;

  postInstall =
  ''
    for n in "$out/bin/"*; do wrapProgram "$n" --suffix MAUDE_LIB ':' "$out/share/maude"; done
    mkdir -p $out/share/maude
    cp ${fullMaude} $out/share/maude/full-maude.maude
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

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
