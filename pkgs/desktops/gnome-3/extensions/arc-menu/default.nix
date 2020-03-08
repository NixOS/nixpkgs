{ stdenv, fetchFromGitLab, glib, gettext, substituteAll, gnome-menus }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-arc-menu";
  version = "43";

  src = fetchFromGitLab {
    owner = "LinxGem33";
    repo = "Arc-Menu";
    rev = "v${version}-Stable";
    sha256 = "1rspl89bxqy0wla8cj0h1d29gp38xg1vmvhc1qg7bl46ank4yp5q";
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

  meta = with stdenv.lib; {
    description = "Gnome shell extension designed to replace the standard menu found in Gnome 3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dkabot ];
    homepage = "https://gitlab.com/LinxGem33/Arc-Menu";
  };
}
