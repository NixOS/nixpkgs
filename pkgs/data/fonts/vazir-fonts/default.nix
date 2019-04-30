{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "vazir-fonts";
  version = "19.2.0";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "vazir-font";
    rev = "v${version}";
    sha256 = "0p96y4q20nhpv7hxca6rncfcb14iqy2vacv0xl55wkwqkm4wvzgr";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/vazir-fonts
    cp -v $( find . -name '*.ttf') $out/share/fonts/vazir-fonts

  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/rastikerdar/vazir-font;
    description = "A Persian (Farsi) Font - قلم (فونت) فارسی وزیر";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
