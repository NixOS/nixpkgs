{ stdenv
, lib
, fetchFromGitHub
, dtkgui
, pkg-config
, cmake
, qttools
, qtmultimedia
, qtsvg
, qtx11extras
, wrapQtAppsHook
, cups
, gsettings-qt
, libstartup_notification
, xorg
}:

stdenv.mkDerivation rec {
  pname = "dtkwidget";
  version = "5.6.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-APk2p8pdLsaKvPp95HtEI1F1LM4ySUL+fhGsC5vHasU=";
  };

  postPatch = ''
    substituteInPlace src/widgets/dapplication.cpp \
      --replace "auto dataDirs = DStandardPaths::standardLocations(QStandardPaths::GenericDataLocation);" \
                "auto dataDirs = DStandardPaths::standardLocations(QStandardPaths::GenericDataLocation) << \"$out/share\";"
  '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtmultimedia
    qtsvg
    qtx11extras
    cups
    gsettings-qt
    libstartup_notification
    xorg.libXdmcp
  ];

  propagatedBuildInputs = [ dtkgui ];

  cmakeFlags = [
    "-DDVERSION=${version}"
    "-DBUILD_DOCS=OFF"
    "-DMKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs/modules"
  ];

  meta = with lib; {
    description = "Deepin graphical user interface library";
    homepage = "https://github.com/linuxdeepin/dtkwidget";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
