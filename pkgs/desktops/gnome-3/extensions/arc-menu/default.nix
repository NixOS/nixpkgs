{ stdenv, fetchFromGitLab, glib, gettext, substituteAll, gnome-menus }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-arc-menu";
  version = "33.2";

  src = fetchFromGitLab {
    owner = "LinxGem33";
    repo = "Arc-Menu";
    rev = "v${version}-dev";
    sha256 = "1dd9ysiyza6drwdv4qcxyijy7yijirjf2fd1aq5jv8s4bqajcqf4";
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

  makeFlags = [ "INSTALL_BASE=${placeholder "out"}/share/gnome-shell/extensions" ];

  meta = with stdenv.lib; {
    description = "Gnome shell extension designed to replace the standard menu found in Gnome 3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dkabot ];
    homepage = https://gitlab.com/LinxGem33/Arc-Menu;
  };
}
