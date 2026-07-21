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
  version = "0.2.4-unstable-2025-11-24";

  src = fetchFromGitLab {
    group = "pub";
    owner = "ltest";
    repo = "luncov";
    domain = "git.frama-c.com";
    rev = "76b14a41ae9e5eacb90649cb1401a75e37a61d52"; # latest commit from stable/germanium branch
    hash = "sha256-dp693isevR4N4V/3FZ1lnbw0xjR+CuAK8BD/Bwvny0E";
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
