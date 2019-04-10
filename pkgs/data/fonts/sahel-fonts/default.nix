{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "sahel-fonts";
  version = "1.0.0-alpha22";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "sahel-font";
    rev = "v${version}";
    sha256 = "1kx7byzb5zxspq0i4cvgf4q7sm6xnhdnfyw9zrb1wfmdv3jzaz7p";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/sahel-fonts
    cp -v $( find . -name '*.ttf') $out/share/fonts/sahel-fonts
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/rastikerdar/sahel-font;
    description = "A Persian (farsi) Font - فونت (قلم) فارسی ساحل";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
