{ stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  name = "gnome-shell-dash-to-panel-${version}";
  version = "11";

  src = fetchFromGitHub {
    owner = "jderose9";
    repo = "dash-to-panel";
    rev = "v${version}";
    sha256 = "1bfcnrhw6w8yrz8sw520kwwshmplkg4awpvz07kg4d73m6zn4mw2";
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
