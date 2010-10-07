{ stdenv, fetchurl, flex, bison, ncurses, buddy, tecla, libsigsegv, gmpxx, makeWrapper }:

stdenv.mkDerivation rec {
  name = "maude-2.5";

  src = fetchurl {
    url = "http://maude.cs.uiuc.edu/download/current/Maude-2.5.tar.gz";
    sha256 = "16bvnbyi257z87crzkw9gx2kz13482hnjnik22c2p2ml4rj4lpfw";
  };

  fullMaude = fetchurl {
    url = "http://maude.cs.uiuc.edu/download/current/FM2.5/full-maude25.maude";
    sha256 = "1d0izdbmhpifb2plnkk3cp7li2z60r8a8ppxhifmfpzi6x6pfvrd";
  };

  buildInputs = [flex bison ncurses buddy tecla gmpxx libsigsegv makeWrapper];

  configurePhase = ''./configure --disable-dependency-tracking --prefix=$out --datadir=$out/share/maude TECLA_LIBS="-ltecla -lncursesw" CFLAGS="-O3" CXXFLAGS="-O3"'';

  # The test suite is known to fail on Darwin. If maude is ever updated to a
  # new version, this exception ought to be removed again.
  doCheck = !stdenv.isDarwin;

  postInstall =
  ''
    for n in $out/bin/*; do wrapProgram "$n" --suffix MAUDE_LIB ':' "$out/share/maude"; done
    ensureDir $out/share/maude
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
