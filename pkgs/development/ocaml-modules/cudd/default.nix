{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  fetchurl,
}:

let
  cuddTarball = fetchurl {
    url = "https://github.com/ivmai/cudd/archive/refs/tags/cudd-3.0.0.tar.gz";
    hash = "sha256-X+FFBBxZRonm589M1iPV8rfDYmFwi+jJpyrtcs9nrM4=";
  };
in

buildDunePackage (finalAttrs: {
  pname = "cudd";
  version = "0.1.3";

  src = fetchFromGitLab {
    domain = "git.frama-c.com";
    owner = "pub/codex";
    repo = "cudd.ml";
    tag = finalAttrs.version;
    hash = "sha256-RLImpj+5fPjZTds+r1q5rGn001QQo2GzOvJQWJlBR64=";
  };

  postUnpack = ''
    cp ${cuddTarball} $sourceRoot/cudd/cudd.tar.gz
  '';

  meta = {
    description = "Minimal cudd bindings";
    homepage = "https://git.frama-c.com/pub/codex/cudd.ml";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ redianthus ];
  };
})
