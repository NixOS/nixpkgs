{
  buildDunePackage,
  lib,
  fetchurl,
  uri,
  base64,
  digestif,
  logs,
  fmt,
  lwt,
  mirage-crypto,
  mirage-crypto-ec,
  mirage-crypto-pk,
  x509,
  yojson,
  ounit2,
  ptime,
  domain-name,
}:

buildDunePackage rec {
  pname = "letsencrypt";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/mmaker/ocaml-letsencrypt/releases/download/v${version}/letsencrypt-${version}.tbz";
    hash = "sha256-koNG19aoLY28Hb7GyuPuJUyrCAE59n2vjbH4z0ykGvA=";
  };

  minimalOCamlVersion = "4.08";

  buildInputs = [
    fmt
    ptime
    domain-name
  ];

  propagatedBuildInputs = [
    logs
    yojson
    lwt
    base64
    digestif
    mirage-crypto
    mirage-crypto-ec
    mirage-crypto-pk
    x509
    uri
  ];

  doCheck = true;
  checkInputs = [ ounit2 ];

  meta = {
    description = "ACME implementation in OCaml";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.sternenseemann ];
    homepage = "https://github.com/mmaker/ocaml-letsencrypt";
  };
}
