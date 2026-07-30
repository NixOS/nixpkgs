{
  lib,
  buildDunePackage,
  dune-site,
  fetchzip,
  frama-c,
}:

buildDunePackage (finalAttrs: {
  pname = "frama-c-lannotate";
  version = "0.2.5";

  src = fetchzip {
    url = "https://git.frama-c.com/pub/ltest/lannotate/-/archive/${finalAttrs.version}/lannotate-${finalAttrs.version}.tar.bz2";
    hash = "sha256-S7/So+1HBdkeq4k7BisEe2gpzW4vHFi6x8J8evaPgRw=";
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
