{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  glib,
  gettext,
  xwininfo,
  xprop,
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-no-title-bar";
  version = "11";

  src = fetchFromGitHub {
    owner = "poehlerj";
    repo = "no-title-bar";
    rev = "V_${version}";
    sha256 = "07ddw47binlsbyvgy4xkdjvd40zyp7nwd17r6k7w54d50vmnwhvb";
  };

  nativeBuildInputs = [
    glib
    gettext
  ];

  patches = [
    (replaceVars ./fix-paths.patch {
      xprop = "${xprop}/bin/xprop";
      xwininfo = "${xwininfo}/bin/xwininfo";
    })
  ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];

  passthru = {
    extensionUuid = "no-title-bar@jonaspoehler.de";
  };

  meta = {
    description = "Integrates maximized windows with the top panel";
    homepage = "https://github.com/poehlerj/no-title-bar";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ svsdep ];
    platforms = lib.platforms.linux;
  };
}
