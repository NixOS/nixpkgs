{ stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  name = "gnome-shell-dash-to-panel-${version}";
  version = "16";

  src = fetchFromGitHub {
    owner = "jderose9";
    repo = "dash-to-panel";
    rev = "v${version}";
    sha256 = "1gi2qfinafihax0j0rbs1k5nf6msdv86gzl2vfkc8s6gfkncv9bp";
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
