{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  efl,
  directoryListingUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "evisum";
  version = "2.0.13";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/evisum/evisum-${finalAttrs.version}.tar.xz";
    hash = "sha256-ntih3sFIbogai4tlG6YPla1nlgzxDbhGIkk0sYg5LD4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    efl
  ];

  passthru.updateScript = directoryListingUpdater { };

  meta = {
    description = "System and process monitor written with EFL";
    mainProgram = "evisum";
    homepage = "https://git.enlightenment.org/enlightenment/evisum";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.enlightenment ];
  };
})
