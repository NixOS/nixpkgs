{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "shabnam-fonts";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "shabnam-font";
    rev = "v${version}";
    sha256 = "1y4w16if2y12028b9vyc5l5c5bvcglhxacv380ixb8fcc4hfakmb";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/shabnam-fonts
    cp -v $( find . -name '*.ttf') $out/share/fonts/shabnam-fonts
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/rastikerdar/shabnam-font;
    description = "A Persian (Farsi) Font - فونت (قلم) فارسی شبنم";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
