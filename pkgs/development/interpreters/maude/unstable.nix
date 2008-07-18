{ stdenv, fetchurl, flex, bison, ncurses, buddy, tecla, gmp }:

stdenv.mkDerivation rec
{
  name = "maude-2.4-alpha-91";
  meta =
  {
    homepage = "http://maude.cs.uiuc.edu/";
    description = "Maude -- a high-level specification language";
    license = "GPLv2";
  };
  src = fetchurl
  {
    url = "http://www.csl.sri.com/users/eker/Maude/Alpha91/Maude-2.4.tar.gz";
    sha256 = "1nzxj8x1379nxsdvldqy55wl513hdi4xwf8i2bhngz7s8228vs37";
  };
  fullMaude = fetchurl
  {
    url = "http://www.lcc.uma.es/~duran/FullMaude/FM23j/full-maude.maude";
    sha256 = "2b069a351d39098d11e75dd9e5b772e0cf35843bf25f5dde45f6b700dd6445f4";
  };
  buildInputs = [flex bison ncurses buddy tecla gmp];
  configurePhase = ''./configure --disable-dependency-tracking --prefix=$out TECLA_LIBS="-ltecla -lncursesw" CFLAGS="-O3" CXXFLAGS="-O3"'';
  doCheck = true;
  postInstall =
  ''
    ensureDir $out/share/maude
    cp src/Main/*.maude ${fullMaude} $out/share/maude/
  '';
}
