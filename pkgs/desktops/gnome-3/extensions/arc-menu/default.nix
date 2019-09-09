{ stdenv, fetchFromGitLab, glib, gettext, substituteAll, gnome-menus }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-arc-menu";
  version = "31";

  src = fetchFromGitLab {
    owner = "LinxGem33";
    repo = "Arc-Menu";
    rev = "v${version}-stable";
    sha256 = "124jgdy6mw76nrkq3f0y7qkhdm39wg273zifdvwbgpvirwzxbia1";
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

  makeFlags = [ "INSTALL_BASE=$(out)/share/gnome-shell/extensions" ];

  meta = with stdenv.lib; {
    description = "Gnome shell extension designed to replace the standard menu found in Gnome 3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dkabot ];
    homepage = https://gitlab.com/LinxGem33/Arc-Menu;
  };
}
