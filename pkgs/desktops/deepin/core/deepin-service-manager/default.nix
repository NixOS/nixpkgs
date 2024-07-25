{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "deepin-service-manager";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-gTzyQHFPyn2+A+o+4VYySDBCZftfG2WnTXuqzeF+QhA=";
  };

  postPatch = ''
    for file in $(grep -rl "/usr/bin/deepin-service-manager"); do
      substituteInPlace $file --replace "/usr/bin/deepin-service-manager" "$out/bin/deepin-service-manager"
    done
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  meta = with lib; {
    description = "Manage DBus service on Deepin";
    mainProgram = "deepin-service-manager";
    homepage = "https://github.com/linuxdeepin/deepin-service-manager";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
