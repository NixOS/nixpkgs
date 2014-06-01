{ stdenv, fetchurl, flex, bison, ncurses, buddy, tecla, libsigsegv, gmpxx, makeWrapper, unzip }:

stdenv.mkDerivation rec {
  name = "maude-2.6";

  src = fetchurl {
    url = "http://maude.cs.uiuc.edu/download/current/Maude-2.6.tar.gz";
    sha256 = "182abzhvjvlaa21aqv7802v3bs57a4dm7cw09s3mqmih7nzpkfm5";
  };

  fullMaude = fetchurl {
    url = "http://maude.lcc.uma.es/FullMaude/FM261e/full-maude.maude.zip";
    sha256 = "0g0chfrzc7923sh17zdy731wpsgnwz7rxci0jqqmrphlshwzqm2h";
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
    ${unzip}/bin/unzip ${fullMaude} -d $out/share/maude
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
