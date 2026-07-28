{
  lib,
  stdenv,
  fetchurl,
  directoryListingUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "which";
  version = "2.25";

  src = fetchurl {
    url = "mirror://gnu/which/which-${finalAttrs.version}.tar.gz";
    hash = "sha256-HLg+T3AuYLghGrXsTCr7qxsd7IAglFan0vr3WE7SJeo=";
  };
  patches = [
    ./gcc15.patch
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  passthru.updateScript = directoryListingUpdater {
    inherit (finalAttrs) pname version;
    url = "https://ftp.gnu.org/gnu/which/";
  };

  outputs = [
    "out"
    "info"
    "man"
  ];

  meta = {
    homepage = "https://www.gnu.org/software/which/";
    description = "Shows the full path of (shell) commands";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
    mainProgram = "which";
    platforms = lib.platforms.all;
  };
})
