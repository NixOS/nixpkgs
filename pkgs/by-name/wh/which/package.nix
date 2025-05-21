{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "which";
  version = "2.23";

  src = fetchurl {
    url = "mirror://gnu/which/which-${version}.tar.gz";
    hash = "sha256-osVYIm/E2eTOMxvS/Tw/F/lVEV0sAORHYYpO+ZeKKnM=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.gnu.org/software/which/";
    description = "Shows the full path of (shell) commands";
    license = lib.licenses.gpl3Plus;
    mainProgram = "which";
    platforms = lib.platforms.all;
  };
}
