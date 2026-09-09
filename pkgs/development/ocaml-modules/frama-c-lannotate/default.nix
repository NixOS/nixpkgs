{
  lib,
  buildDunePackage,
  dune-site,
  fetchFromGitLab,
  frama-c,
}:

buildDunePackage (finalAttrs: {
  pname = "frama-c-lannotate";
  version = "0.2.6";

  src = fetchFromGitLab {
    domain = "git.frama-c.com";
    group = "pub";
    owner = "ltest";
    repo = "lannotate";
    rev = finalAttrs.version;
    hash = "sha256-F08YrRtRdRZXNfGqdIc0ATOfWN8Kw0RXYY579da9Xuw=";
  };

  propagatedBuildInputs = [
    dune-site
    frama-c
  ];

  meta = {
    description = "Lannotate plugin of Frama-C, part of the LTest suite";
    homepage = "https://frama-c.com/fc-plugins/ltest.html";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ redianthus ];
  };
})
