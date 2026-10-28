{
  buildDunePackage,
  lib,
  fetchurl,
  jws,
  lun,
  logs,
  fmt,
  x509,
  ounit2,
  ptime,
  domain-name,
}:

buildDunePackage (finalAttrs: {
  pname = "letsencrypt";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/mmaker/ocaml-letsencrypt/releases/download/v${finalAttrs.version}/letsencrypt-${finalAttrs.version}.tbz";
    hash = "sha256-jv/CxJFhqb4ouC7CvYMXHhVRmgpdlMPIwPYPAMt7Bts=";
  };

  buildInputs = [
    fmt
    ptime
    domain-name
  ];

  propagatedBuildInputs = [
    jws
    logs
    lun
    x509
  ];

  doCheck = true;
  checkInputs = [ ounit2 ];

  meta = {
    description = "ACME implementation in OCaml";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.sternenseemann ];
    homepage = "https://github.com/mmaker/ocaml-letsencrypt";
  };
})
