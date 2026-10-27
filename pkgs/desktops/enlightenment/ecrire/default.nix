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
  pname = "ecrire";
  version = "0.2.0";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/ecrire/ecrire-${finalAttrs.version}.tar.xz";
    hash = "sha256-2WRZh5DVsmdn4ht9vAnKFoZ/Uw1Q+jY8dpT9PFCZX98=";
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
    description = "EFL simple text editor";
    mainProgram = "ecrire";
    homepage = "https://www.enlightenment.org/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.enlightenment ];
  };
})
