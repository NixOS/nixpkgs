{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "source-sans-pro-2.010";
  src = fetchurl {
    url = "https://github.com/adobe-fonts/source-sans-pro/archive/2.010R-ro/1.065R-it.tar.gz";
    sha256 = "1s3rgia6x9fxc2pvlwm203grqkb49px6q0xnh8kbqxqsgna615p2";
  };

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    find . -name "*.otf" -exec cp {} $out/share/fonts/opentype \;
  '';

  meta = with stdenv.lib; {
    homepage = http://sourceforge.net/adobe/sourcesans;
    description = "A set of OpenType fonts designed by Adobe for UIs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
