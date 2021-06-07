{ lib, fetchurl, buildDunePackage
, cstruct, cstruct-sexp, domain-name, fmt, ppx_cstruct, ppx_sexp_conv, logs, hkdf, mirage-crypto, mirage-crypto-ec, mirage-crypto-pk, mirage-crypto-rng, ocaml_lwt, ptime, rresult, sexplib, x509
, alcotest, cstruct-unix, ounit2
}:

buildDunePackage rec {
  pname = "tls";
  version = "0.13.1";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-tls/releases/download/v${version}/tls-v${version}.tbz";
    sha256 = "ca95fa59a82f7d38b0b495fc0cd1ff54e7728492a292895d0067c1ba9de81b7b";
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
  ];

  meta = with lib; {
    homepage = "https://github.com/mirleft/ocaml-tls";
    description = "TLS in pure OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
