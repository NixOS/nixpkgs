{ stdenvNoCC
, lib
, fetchFromGitHub
, gtk-engine-murrine
}:

stdenvNoCC.mkDerivation rec {
  pname = "deepin-gtk-theme";
  version = "unstable-2022-07-26";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-gtk-theme";
    rev = "5ac53cbdfba4e6804451605db726876a3be9fb07";
    sha256 = "sha256-NJ5URKYs4rVzddXxkwJK9ih40f8McVEbj3G1tPFAiMs";
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
