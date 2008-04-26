{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "redhat-liberation";
  src = fetchurl {
    url = http://www.redhat.com/f/fonts/liberation-fonts-ttf-3.tar.gz;
    sha256 = "13zzyqyi3mf676aj3fg9122asyykpx94mk689r1p2ab1axyg4k0p";
  };
  installPhase = ''
    ensureDir $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';
}
  
