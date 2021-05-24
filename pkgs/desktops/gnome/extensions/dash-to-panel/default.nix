{ lib, stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-dash-to-panel";
  version = "40";

  src = fetchFromGitHub {
    owner = "home-sweet-gnome";
    repo = "dash-to-panel";
    rev = "v${version}";
    sha256 = "07jq8d16nn62ikis896nyfn3q02f5srj754fmiblhz472q4ljc3p";
  };

  buildInputs = [
    glib gettext
  ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];

  uuid = "dash-to-panel@jderose9.github.com";

  meta = with lib; {
    description = "An icon taskbar for Gnome Shell";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mounium ];
    homepage = "https://github.com/jderose9/dash-to-panel";
  };
}
