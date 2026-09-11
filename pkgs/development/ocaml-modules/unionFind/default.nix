{
  lib,
  fetchFromGitLab,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "unionFind";
  version = "20250818";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "fpottier";
    repo = "unionfind";
    tag = finalAttrs.version;
    hash = "sha256-q/3Wx2/JvFO3m51OvMwO6bz+s7+4Vjs4pFgy5+OinNo=";
  };

  meta = {
    description = "Implementations of the union-find data structure";
    license = lib.licenses.lgpl2Only;
    homepage = "https://gitlab.inria.fr/fpottier/unionfind";
    maintainers = [ lib.maintainers.vbgl ];
  };
})
