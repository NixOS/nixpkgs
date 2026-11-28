{
  lib,
  fetchFromGitLab,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "fix";
  version = "20261126";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "fpottier";
    repo = "fix";
    tag = finalAttrs.version;
    hash = "sha256-Huns1EfuTRugaaItDbFAlHsa4Wy2VB+fAZb+LWWw6ko=";
  };

  meta = {
    homepage = "https://gitlab.inria.fr/fpottier/fix/";
    description = "Simple OCaml module for computing the least solution of a system of monotone equations";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ vbgl ];
  };
})
