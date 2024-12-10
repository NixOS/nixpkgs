{
  lib,
  fetchurl,
  buildDunePackage,
  saturn,
  domain-local-await,
  kcas,
  mirage-clock-unix,
  qcheck-stm,
}:

buildDunePackage rec {
  pname = "domainslib";
  version = "0.5.1";

  minimalOCamlVersion = "5.0";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/domainslib/releases/download/${version}/domainslib-${version}.tbz";
    hash = "sha256-KMJd+6XZmUSXNsXW/KXgvnFtgY9vODeW3vhL77mDXQE=";
  };

  propagatedBuildInputs = [
    domain-local-await
    saturn
  ];

  doCheck = true;
  checkInputs = [
    kcas
    mirage-clock-unix
    qcheck-stm
  ];

  meta = {
    homepage = "https://github.com/ocaml-multicore/domainslib";
    description = "Nested-parallel programming";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
