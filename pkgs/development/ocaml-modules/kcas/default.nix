{
  lib,
  buildDunePackage,
  fetchurl,
  domain-local-await,
  domain-local-timeout,
  alcotest,
}:

buildDunePackage rec {
  pname = "kcas";
  version = "0.6.1";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/kcas/releases/download/${version}/kcas-${version}.tbz";
    hash = "sha256-u3Z8uAvITRUhOcB2EUYjWtpxIFJMvm2O/kyNr/AELWI=";
  };

  propagatedBuildInputs = [
    domain-local-await
    domain-local-timeout
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    homepage = "https://github.com/ocaml-multicore/kcas";
    description = "STM based on lock-free MCAS";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
