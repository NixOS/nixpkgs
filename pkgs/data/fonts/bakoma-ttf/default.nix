{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bakoma-ttf";
  
  src = fetchurl {
    url = http://nixos.org/tarballs/bakoma-ttf.tar.bz2;
    sha256 = "1j1y3cq6ys30m734axc0brdm2q9n2as4h32jws15r7w5fwr991km";
  };
  
  buildPhase = "true";
  installPhase = "mkdir -p $out/share/fonts/truetype; cp ttf/*.ttf $out/share/fonts/truetype";

  meta = {
    description = "TrueType versions of the Computer Modern and AMS TeX Fonts";
    homepage = http://www.ctan.org/tex-archive/fonts/cm/ps-type1/bakoma/ttf/;
  };
}
