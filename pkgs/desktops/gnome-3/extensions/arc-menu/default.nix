{ stdenv, fetchFromGitLab, glib, gettext, substituteAll, gnome-menus }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-arc-menu";
  version = "47";

  src = fetchFromGitLab {
    owner = "arcmenu-team";
    repo = "Arc-Menu";
    rev = "v${version}-Stable";
    sha256 = "1hhjxdm1sm9pddhkkxx532hqqiv9ghvqgn9xszg1jwhj29380fv6";
  };

  patches = [
    (substituteAll {
      src = ./fix_gmenu.patch;
      gmenu_path = "${gnome-menus}/lib/girepository-1.0";
    })
  ];

  buildInputs = [
    glib gettext
  ];

  makeFlags = [ "INSTALLBASE=${placeholder "out"}/share/gnome-shell/extensions" ];

  uuid = "arc-menu@linxgem33.com";

  meta = with stdenv.lib; {
    description = "Gnome shell extension designed to replace the standard menu found in Gnome 3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dkabot ];
    homepage = "https://gitlab.com/LinxGem33/Arc-Menu";
  };
}
