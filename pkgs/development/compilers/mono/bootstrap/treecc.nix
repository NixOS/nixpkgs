{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "treecc";
  version = "0.3.10";

  src = fetchurl {
    url = "mirror://savannah/dotgnu-pnet/treecc-0.3.10.tar.gz";
    hash = "sha256-Xp0gppOODG/t/tDKvH6emEAk5IgbdI0Hbox18a627+c=";
  };

  meta = {
    description = "Tree Compiler-Compiler";
    homepage = "https://www.gnu.org/software/dotgnu/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
