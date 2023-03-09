{ stdenvNoCC
, lib
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "dde-account-faces";
  version = "1.0.12.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-NWjR8qxWi2IrcP0cSF+lLxBJ/GrVpk1BfTjVH0ytinY=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}/var" ];

  meta = with lib; {
    description = "Account faces of deepin desktop environment";
    homepage = "https://github.com/linuxdeepin/dde-account-faces";
    license = with licenses; [ gpl3Plus cc0 ];
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
