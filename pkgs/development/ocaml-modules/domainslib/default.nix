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
  version = "0.5.2";

  minimalOCamlVersion = "5.0";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/domainslib/releases/download/${version}/domainslib-${version}.tbz";
    hash = "sha256-pyDs4stBsqWRrRpEotuezVVz6Le1ES6NRtDydfmvHK8=";
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
