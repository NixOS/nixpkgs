{ stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "go-dbus-factory";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-yzmr61wrBfZi+CuXFhtvOk7EaFtE8y3QyVwwgEDqwKY=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Generate go binding of D-Bus interfaces";
    homepage = "https://github.com/linuxdeepin/go-dbus-factory";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
