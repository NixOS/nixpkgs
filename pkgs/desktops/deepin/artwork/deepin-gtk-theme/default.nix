{ stdenvNoCC
, lib
, fetchFromGitHub
, gtk-engine-murrine
}:

stdenvNoCC.mkDerivation rec {
  pname = "deepin-gtk-theme";
  version = "23.11.23";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-gtk-theme";
    rev = version;
    hash = "sha256-2B2BtbPeg3cEbnEIgdGFzy8MjCMWlbP/Sq4jzG5cjmc=";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Deepin GTK Theme";
    homepage = "https://github.com/linuxdeepin/deepin-gtk-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = teams.deepin.members;
  };
}
