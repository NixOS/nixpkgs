{ stdenvNoCC
, lib
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "deepin-sound-theme";
  version = "15.10.6";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-BvG/ygZfM6sDuDSzAqwCzDXGT/bbA6Srlpg3br117OU=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Freedesktop sound theme for Deepin";
    homepage = "https://github.com/linuxdeepin/deepin-sound-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
