{
  lib,
  stdenv,
  fetchurl,
  qt6,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "veroroute";
  version = "2.40";

  src = fetchurl {
    url = "mirror://sourceforge/veroroute/veroroute-${finalAttrs.version}.tar.gz";
    hash = "sha256-4Wmvstjq0u8u5EFlvcGRb+UshZbtzAfRShQS2NFCllA=";
  };

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    qt6.qtbase
  ];

  preConfigure = ''
    cd Src/
  '';

  passthru.tests = {
    veroroute = nixosTests.veroroute;
  };

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
