{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-themes";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "c7SGsnF2t2IrQFZODVmZS0ijJ7G1KiLWOLm7Rs2hehs=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-themes";
    description = "Themes, graphics and icons for LXQt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
