{ stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  name = "gnome-shell-dash-to-dock-${version}";
  version = "64";

  src = fetchFromGitHub {
    owner = "micheleg";
    repo = "dash-to-dock";
    rev = "extensions.gnome.org-v" + version;
    sha256 = "1cfkdi4raim50wif47fly4c0lzyamysv40qd5ppr1h824bamzxcm";
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
