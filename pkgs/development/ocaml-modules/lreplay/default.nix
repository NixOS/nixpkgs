{
  lib,
  buildDunePackage,
  dune-site,
  fetchzip,
  frama-c,
  menhir,
}:

buildDunePackage (finalAttrs: {
  pname = "lreplay";
  version = "0.1.1";

  src = fetchzip {
    url = "https://git.frama-c.com/pub/ltest/lreplay/-/archive/${finalAttrs.version}/lreplay-${finalAttrs.version}.tar.bz2";
    hash = "sha256-FSICl9x/uL4hMVFz5Ef7NYKATZDdtYY9DRU0AZKSDD8=";
  };

  nativeBuildInputs = [
    menhir
  ];

  meta = {
    description = "Lreplay plugin of Frama-C, part of the LTest suite";
    homepage = "https://frama-c.com/fc-plugins/ltest.html";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ redianthus ];
    mainProgram = "lreplay";
  };
})
