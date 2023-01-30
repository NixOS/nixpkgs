{ lib, fetchurl, buildDunePackage
, cstruct, cstruct-sexp, domain-name, fmt, ppx_cstruct, ppx_sexp_conv, logs, hkdf, mirage-crypto, mirage-crypto-ec, mirage-crypto-pk, mirage-crypto-rng, ocaml_lwt, ptime, sexplib, x509
, ipaddr, ipaddr-sexp
, alcotest, cstruct-unix, ounit2, randomconv
}:

buildDunePackage rec {
  pname = "tls";
  version = "0.15.4";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-tls/releases/download/v${version}/tls-${version}.tbz";
    sha256 = "sha256-X40dVrBvYGnv0dCj3gxFy0iNPRPrfxMshOx7o/DRw4I=";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [
    cstruct
    cstruct-sexp
    domain-name
    fmt
    ppx_cstruct
    ppx_sexp_conv
    logs
    hkdf
    mirage-crypto
    mirage-crypto-ec
    mirage-crypto-pk
    mirage-crypto-rng
    ocaml_lwt
    ptime
    sexplib
    x509
    ipaddr
    ipaddr-sexp
  ];

  doCheck = true;
  nativeCheckInputs = [
    alcotest
    cstruct-unix
    ounit2
    randomconv
  ];

  meta = with lib; {
    homepage = "https://github.com/mirleft/ocaml-tls";
    description = "TLS in pure OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
