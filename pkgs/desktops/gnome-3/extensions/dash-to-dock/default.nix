{ stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-dash-to-dock-unstable";
  version = "2020-03-19";

  src = fetchFromGitHub {
    owner = "micheleg";
    repo = "dash-to-dock";
    # rev = "extensions.gnome.org-v" + version;
    rev = "8c94a8d6db47ebc1273e690f4e0ba5e592f7f268";
    sha256 = "7nNfxAINqOIJCgYXYaPck2EJ1IOmzt6AkfDFknZ8GaI=";
  };

  nativeBuildInputs = [
    glib gettext
  ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];

  meta = with stdenv.lib; {
    description = "A dock for the Gnome Shell";
    license = licenses.gpl2;
    maintainers = with maintainers; [ eperuffo ];
    homepage = "https://micheleg.github.io/dash-to-dock/";
  };
}
