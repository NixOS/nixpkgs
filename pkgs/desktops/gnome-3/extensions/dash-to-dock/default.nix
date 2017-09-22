{ stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  name = "gnome-shell-dash-to-dock-${version}";
  version = "v60";

  src = fetchFromGitHub {
    owner = "micheleg";
    repo = "dash-to-dock";
    rev = "extensions.gnome.org-" + version;
    sha256 = "0w9km1zcxcskrsfr392zx945k227qajnw09pxc20d1vwv78wlgy3";
  };

  nativeBuildInputs = [
    glib gettext
  ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];

  meta = with stdenv.lib; {
    description = "A dock for the Gnome Shell";
    license = licenses.gpl2;
    maintainers = with maintainers; [ eperuffo ];
    homepage = https://micheleg.github.io/dash-to-dock/;
  };
}
