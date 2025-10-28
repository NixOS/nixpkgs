{
  lib,
  fetchFromGitLab,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "unionFind";
  version = "20250818";

  useDune2 = true;
  minimalOCamlVersion = "4.05";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "fpottier";
    repo = pname;
    rev = version;
    sha256 = "sha256-q/3Wx2/JvFO3m51OvMwO6bz+s7+4Vjs4pFgy5+OinNo=";
  };

  meta = {
    description = "Implementations of the union-find data structure";
    license = lib.licenses.lgpl2Only;
    inherit (src.meta) homepage;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
