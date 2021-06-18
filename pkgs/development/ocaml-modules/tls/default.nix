{ lib, fetchurl, buildDunePackage
, cstruct, cstruct-sexp, domain-name, fmt, ppx_cstruct, ppx_sexp_conv, logs, hkdf, mirage-crypto, mirage-crypto-ec, mirage-crypto-pk, mirage-crypto-rng, ocaml_lwt, ptime, rresult, sexplib, x509
, alcotest, cstruct-unix, ounit2, randomconv
}:

buildDunePackage rec {
  pname = "tls";
  version = "0.13.2";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-tls/releases/download/v${version}/tls-v${version}.tbz";
    sha256 = "sha256-IE6Fuvem8A3lZ/M8GLNYNwCG+v7BbPQ4QdYS+fKT50c=";
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
    rresult
    sexplib
    x509
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
