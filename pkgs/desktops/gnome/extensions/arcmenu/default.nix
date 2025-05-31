{
  lib,
  stdenv,
  fetchFromGitLab,
  glib,
  gettext,
  replaceVars,
  gnome-menus,
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-arcmenu";
  version = "65";

  src = fetchFromGitLab {
    owner = "arcmenu";
    repo = "ArcMenu";
    rev = "v${version}";
    hash = "sha256-EEK600DwIQAPWR07IMPNZFiWWkiG0blp/D0VKAcc7ns=";
  };

  patches = [
    (replaceVars ./fix_gmenu.patch {
      gmenu_path = "${gnome-menus}/lib/girepository-1.0";
    })
  ];

  buildInputs = [
    glib
    gettext
  ];

  makeFlags = [ "INSTALLBASE=${placeholder "out"}/share/gnome-shell/extensions" ];

  passthru = {
    extensionUuid = "arcmenu@arcmenu.com";
    extensionPortalSlug = "arcmenu";
  };

  meta = with lib; {
    description = "Application menu for GNOME Shell, designed to provide a more traditional user experience and workflow";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dkabot ];
    homepage = "https://gitlab.com/arcmenu/ArcMenu";
  };
}
