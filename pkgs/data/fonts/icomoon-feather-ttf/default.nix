{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "icomoon-feather-ttf";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/adi1090x/polybar-themes/blob/master/fonts/feather.ttf?raw=true";
    sha256 = "90ac8162af2bebe68bfef2d62e056a8131633d6cc685876ab0c8264213810158";
  };

  dontUnpack = true;

  installPhase = ''
    install -m 644 -D ${src} $out/share/fonts/truetype/icomoon-feather.ttf
  '';

  meta = with lib; {
    description = "Icomoon feather font";
    homepage = "https://github.com/feathericons/feather";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ gekoke ];
    platforms = platforms.all;
  };
}
