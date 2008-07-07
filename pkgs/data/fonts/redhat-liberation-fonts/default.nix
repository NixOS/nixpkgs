{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "redhat-liberation";
  src = fetchurl {
    url = https://www.redhat.com/f/fonts/liberation-fonts.tar.gz;
    sha256 = "5749c27f3deb5da323961e86efed1306fc072bea9065790d0047ad61471be6a5";
  };
  installPhase = ''
    ensureDir $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';
}
  
