{
  lib,
  buildDunePackage,
  fetchurl,
  backoff,
  domain-local-await,
  mtime,
  multicore-magic,
  yojson,
}:

buildDunePackage (finalAttrs: {
  pname = "multicore-bench";
  version = "0.1.7";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/multicore-bench/releases/download/${finalAttrs.version}/multicore-bench-${finalAttrs.version}.tbz";
    hash = "sha256-vrp9yiuTwhijhYjeDKPFRGyh/5LeydKWJSyMLZRRXIM=";
  };

  propagatedBuildInputs = [
    backoff
    domain-local-await
    mtime
    multicore-magic
    yojson
  ];

  meta = {
    description = "Framework for writing multicore benchmark executables to run on current-bench";
    homepage = "https://github.com/ocaml-multicore/multicore-bench";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
