{ lib, fetchurl, buildDunePackage
<<<<<<< HEAD
, cstruct, domain-name, fmt, logs, hkdf, mirage-crypto, mirage-crypto-ec, mirage-crypto-pk, mirage-crypto-rng, lwt, ptime, x509
, ipaddr
=======
, cstruct, cstruct-sexp, domain-name, fmt, ppx_cstruct, ppx_sexp_conv, logs, hkdf, mirage-crypto, mirage-crypto-ec, mirage-crypto-pk, mirage-crypto-rng, ocaml_lwt, ptime, sexplib, x509
, ipaddr, ipaddr-sexp
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, alcotest, cstruct-unix, ounit2, randomconv
}:

buildDunePackage rec {
  pname = "tls";
<<<<<<< HEAD
  version = "0.17.1";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-tls/releases/download/v${version}/tls-${version}.tbz";
    hash = "sha256-gBDStt4UjaIoaSgYHSM71yD6YPoVez1CULyg3QCMXT8=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    cstruct
    domain-name
    fmt
=======
  version = "0.16.0";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-tls/releases/download/v${version}/tls-${version}.tbz";
    sha256 = "sha256-uvIDZLNy6E/ce7YmzUUVaOeGRaHqPSUzuEPQDMu09tM=";
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    logs
    hkdf
    mirage-crypto
    mirage-crypto-ec
    mirage-crypto-pk
    mirage-crypto-rng
<<<<<<< HEAD
    lwt
    ptime
    x509
    ipaddr
=======
    ocaml_lwt
    ptime
    sexplib
    x509
    ipaddr
    ipaddr-sexp
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
