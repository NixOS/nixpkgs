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
  version = "70.0";

  src = fetchFromGitLab {
    owner = "arcmenu";
    repo = "ArcMenu";
    rev = "v${version}";
    hash = "sha256-ir+N1SaR8g+b4CUW0VcTE3PLd7aUGz2coCDqgtZVT/A=";
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

  meta = {
    description = "Application menu for GNOME Shell, designed to provide a more traditional user experience and workflow";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dkabot ];
    homepage = "https://gitlab.com/arcmenu/ArcMenu";
  };
}
