{
  lib,
  buildDunePackage,
  dune-site,
  fetchzip,
  frama-c,
  menhir,
  unionFind,
  why3,
}:

buildDunePackage (finalAttrs: {
  pname = "frama-c-luncov";
  version = "0.2.4";

  src = fetchzip {
    url = "https://git.frama-c.com/pub/ltest/luncov/-/archive/${finalAttrs.version}/luncov-${finalAttrs.version}.tar.bz2";
    hash = "sha256-E7zzm9qs34V+sRHElpe1JKHjeyXGALXVj1DNMVzlWn0=";
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
