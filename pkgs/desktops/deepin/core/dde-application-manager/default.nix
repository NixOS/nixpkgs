{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, wrapQtAppsHook
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "dde-application-manager";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-ImyXSyQWMFLvmtx9mBxrr4/IFOgOH1BW650mbiwFh5U=";
  };

  patches = [
    (fetchpatch {
      name = "set-more-scale-envs-to-application.patch";
      url = "https://github.com/linuxdeepin/dde-application-manager/commit/a1f8ad276d88c81249dd3468779862186a180238.patch";
      hash = "sha256-/iKg6NZZomNEKYsZCZP1IfNr7ZAXiA9RVBnyf+M/f4w=";
    })
    (fetchpatch {
      name = "support-execSearchPath-to-prevent-systemd-from-finding-binaries.patch";
      url = "https://github.com/linuxdeepin/dde-application-manager/commit/2eaca7c6b8b841d571e9d3510f9f14c321cd976e.patch";
      hash = "sha256-GWUIv4NIBLQpnY4GcjLShMjiXAfPi3zKdol3whchC/Y=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  meta = with lib; {
    description = "Application manager for DDE";
    mainProgram = "dde-application-manager";
    homepage = "https://github.com/linuxdeepin/dde-application-manager";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
