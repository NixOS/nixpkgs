{ lib, fetchFromGitHub, buildDunePackage
, cstruct, cstruct-sexp, domain-name, fmt, ppx_cstruct, ppx_sexp_conv, logs, hkdf, mirage-crypto, mirage-crypto-ec, mirage-crypto-pk, mirage-crypto-rng, ocaml_lwt, ptime, rresult, sexplib, x509
, alcotest, cstruct-unix, ounit2, randomconv
}:

buildDunePackage rec {
  pname = "tls";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "mirleft";
    repo = "ocaml-tls";
    rev = "v${version}";
    sha256 = "vzWFGSvymliUwkyeaF3BIIq8VO5MTnKLUzm7mI34c5g=";
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
