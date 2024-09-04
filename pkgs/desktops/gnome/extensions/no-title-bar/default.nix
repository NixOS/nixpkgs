{ lib, stdenv, fetchFromGitHub, substituteAll, glib, gettext, xorg }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-no-title-bar";
  version = "11";

  src = fetchFromGitHub {
    owner = "poehlerj";
    repo = "no-title-bar";
    rev = "V_${version}";
    sha256 = "07ddw47binlsbyvgy4xkdjvd40zyp7nwd17r6k7w54d50vmnwhvb";
  };

  nativeBuildInputs = [ glib gettext ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      xprop = "${xorg.xprop}/bin/xprop";
      xwininfo = "${xorg.xwininfo}/bin/xwininfo";
    })
  ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];

  passthru = {
    extensionUuid = "no-title-bar@jonaspoehler.de";
  };

  meta = with lib; {
    description = "Integrates maximized windows with the top panel";
    homepage = "https://github.com/poehlerj/no-title-bar";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jonafato svsdep ];
    platforms = platforms.linux;
  };
}
