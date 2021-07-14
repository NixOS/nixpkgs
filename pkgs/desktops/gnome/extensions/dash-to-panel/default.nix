{ lib, stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-dash-to-panel";
  version = "43";

  src = fetchFromGitHub {
    owner = "home-sweet-gnome";
    repo = "dash-to-panel";
    rev = "v${version}";
    sha256 = "08n6lwcj943p0vzi2vif7j3nza6xg5z1yka68vwc34ia9ys352m7";
  };

  buildInputs = [
    glib gettext
  ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];

  passthru = {
    extensionUuid = "dash-to-panel@jderose9.github.com";
    extensionPortalSlug = "dash-to-panel";
  };

  meta = with lib; {
    description = "An icon taskbar for Gnome Shell";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mounium ];
    homepage = "https://github.com/jderose9/dash-to-panel";
  };
}
