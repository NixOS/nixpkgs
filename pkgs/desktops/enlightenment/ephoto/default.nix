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
  pname = "ephoto";
  version = "1.6.0";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/ephoto/ephoto-${finalAttrs.version}.tar.xz";
    hash = "sha256-Nrxz884b+cYGYw0AMdFimhFZEeeLeW/R+QMitYhmcNM=";
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
    description = "Image viewer and editor written using the Enlightenment Foundation Libraries";
    mainProgram = "ephoto";
    homepage = "https://www.enlightenment.org/about-ephoto";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.enlightenment ];
  };
})
