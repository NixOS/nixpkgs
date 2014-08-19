{stdenv, fetchgit}:

stdenv.mkDerivation rec {
  name = "aurulent-sans-0.1";
  src = fetchgit {
    url = "https://github.com/deepfire/hartke-aurulent-sans.git";
    rev = "refs/tags/${name}";
    sha256 = "01hvpvbrks40g9k1xr2f1gxnd5wd0sxidgfbwrm94pdi1a36xxrk";
  };
  buildPhase = "true";
  installPhase = "
    fontDir=$out/share/fonts/opentype
    mkdir -p $fontDir
    cp *.otf $fontDir
  ";
  meta = {
    description = "Aurulent Sans";
    longDescription = "Aurulent Sans is a humanist sans serif intended to be used as an interface font.";
    homepage = http://delubrum.org/;
    license = "SIL";
    platforms = stdenv.lib.platforms.all;
  };
}
