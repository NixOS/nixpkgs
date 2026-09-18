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
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/mmaker/ocaml-letsencrypt/releases/download/v${finalAttrs.version}/letsencrypt-${finalAttrs.version}.tbz";
    hash = "sha256-fBSPKtt8roTqhzBlpf9rDg5Y1ieC2lS6XQJNQGncUO0=";
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
