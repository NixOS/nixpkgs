{ stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  name = "gnome-shell-dash-to-panel-${version}";
  version = "19";

  src = fetchFromGitHub {
    owner = "home-sweet-gnome";
    repo = "dash-to-panel";
    rev = "v${version}";
    sha256 = "0r26ph6zq87kvglydv00rf24mshz7l4r38zf9niyp3mxyzz6rwys";
  };

  buildInputs = [
    glib gettext
  ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];

  meta = with stdenv.lib; {
    description = "An icon taskbar for Gnome Shell";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mounium ];
    homepage = https://github.com/jderose9/dash-to-panel;
  };
}
