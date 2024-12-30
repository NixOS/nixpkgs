{
  lib,
  stdenv,
  fetchurl,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "veroroute";
  version = "2.39";

  src = fetchurl {
    url = "mirror://sourceforge/veroroute/veroroute-${finalAttrs.version}.tar.gz";
    hash = "sha256-+qX8NFkPkQGW29uQUEuetgW3muDP56lMJgrGCAo+5pc=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    libsForQt5.qtbase
  ];

  preConfigure = ''
    cd Src/
  '';

  meta = {
    description = "Qt based Veroboard/Perfboard/PCB layout and routing application";
    homepage = "https://sourceforge.net/projects/veroroute";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      nh2
    ];
    platforms = lib.platforms.linux;
  };
})
