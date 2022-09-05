{ lib, fetchurl, buildDunePackage
, cstruct, cstruct-sexp, domain-name, fmt, ppx_cstruct, ppx_sexp_conv, logs, hkdf, mirage-crypto, mirage-crypto-ec, mirage-crypto-pk, mirage-crypto-rng, ocaml_lwt, ptime, sexplib, x509
, ipaddr, ipaddr-sexp
, alcotest, cstruct-unix, ounit2, randomconv
}:

buildDunePackage rec {
  pname = "tls";
  version = "0.15.3";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-tls/releases/download/v${version}/tls-${version}.tbz";
    sha256 = "0nj6fhgrirn8ky4hb24m3ilhr41ynzgk6bqmjs17g8rdibwmdd2x";
  };

  minimumOCamlVersion = "4.08";
  useDune2 = true;

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
  checkInputs = [
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
