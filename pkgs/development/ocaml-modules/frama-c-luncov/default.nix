{
  lib,
  buildDunePackage,
  dune-site,
  fetchFromGitLab,
  frama-c,
  menhir,
  unionFind,
  why3,
}:

buildDunePackage (finalAttrs: {
  pname = "frama-c-luncov";
  version = "0.2.6";

  src = fetchFromGitLab {
    domain = "git.frama-c.com";
    group = "pub";
    owner = "ltest";
    repo = "luncov";
    rev = finalAttrs.version;
    hash = "sha256-rj/JGGr368UlEdtb1yXn9PpkU6fQCdxB8wQ2gIlYmrY=";
  };

  nativeBuildInputs = [
    menhir
  ];

  propagatedBuildInputs = [
    dune-site
    frama-c
    unionFind
    why3
  ];

  meta = {
    description = "Luncov plugin of Frama-C, part of the LTest suite";
    homepage = "https://frama-c.com/fc-plugins/ltest.html";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ redianthus ];
  };
})
