{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "redhat-liberation";
  src = fetchurl {
    url = http://www.redhat.com/f/fonts/liberation-fonts.tar.gz;
    sha256 = "5749c27f3deb5da323961e86efed1306fc072bea9065790d0047ad61471be6a5";
  };
  
  unpackPhase = ''tar -xvf "$src" && sourceRoot="$PWD/liberation-fonts"'';
  installPhase = ''
    ensureDir $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';
}
  
