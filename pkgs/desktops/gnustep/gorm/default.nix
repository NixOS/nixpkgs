{
  lib,
  stdenv,
  fetchzip,
  base,
  back,
  make,
  wrapGNUstepAppsHook,
  gui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gorm";
  version = "1.3.1";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/dev-apps/gorm-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-W+NgbvLjt1PpDiauhzWFaU1/CUhmDACQz+GoyRUyWB8=";
  };

  nativeBuildInputs = [
    make
    wrapGNUstepAppsHook
  ];
  buildInputs = [
    base
    back
    gui
  ];

  meta = {
    description = "Graphical Object Relationship Modeller is an easy-to-use interface designer for GNUstep";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "Gorm";
    maintainers = with lib.maintainers; [
      ashalkhakov
      matthewbauer
      dblsaiko
    ];
    platforms = lib.platforms.linux;
  };
})
