{
  lib,
  stdenv,
  fetchurl,
  directoryListingUpdater,
  withPrefix ? false,
}:

let
  prefix = lib.optionalString withPrefix "g";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "which";
  version = "2.23";

  src = fetchurl {
    url = "mirror://gnu/which/which-${finalAttrs.version}.tar.gz";
    hash = "sha256-osVYIm/E2eTOMxvS/Tw/F/lVEV0sAORHYYpO+ZeKKnM=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  configureFlags = lib.optional withPrefix "--program-prefix=g";

  passthru.updateScript = directoryListingUpdater {
    inherit (finalAttrs) pname version;
    url = "https://ftp.gnu.org/gnu/which/";
  };

  meta = {
    homepage = "https://www.gnu.org/software/which/";
    description = "Shows the full path of (shell) commands";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
    mainProgram = prefix + "which";
    platforms = lib.platforms.all;
  };
})
