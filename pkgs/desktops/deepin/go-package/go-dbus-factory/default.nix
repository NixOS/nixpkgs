{ stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "go-dbus-factory";
  version = "1.10.23";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-6u9Bpoa80j/K1MipncfM378/qmSSMZAlx88jE4hHYBk=";
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
