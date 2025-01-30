{
  lib,
  buildDunePackage,
  fetchurl,
  domain-local-await,
  mtime,
  multicore-magic,
  yojson,
}:

buildDunePackage rec {
  pname = "multicore-bench";
  version = "0.1.4";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/multicore-bench/releases/download/${version}/multicore-bench-${version}.tbz";
    hash = "sha256-iCx5QvhYo/e53cW23Sza2as4aez4HeESVvLPF1DW85A=";
  };

  propagatedBuildInputs = [
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
}
