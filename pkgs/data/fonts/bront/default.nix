{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "bront_fonts";
  version = "unstable-2015-06-28";

  src = fetchFromGitHub {
    owner = "chrismwendt";
    repo = "bront";
    rev = "aef23d9a11416655a8351230edb3c2377061c077";
    sha256 = "1sx2gv19pgdyccb38sx3qnwszksmva7pqa1c8m35s6cipgjhhgb4";
  };

  installPhase = ''
    install -m444 -Dt $out/share/fonts/truetype *Bront.ttf
  '';

  meta = with lib; {
    description = "Bront Fonts";
    longDescription = "Ubuntu Mono Bront and DejaVu Sans Mono Bront fonts.";
    homepage = "https://github.com/chrismwendt/bront";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = [ maintainers.grburst ];
  };
}
