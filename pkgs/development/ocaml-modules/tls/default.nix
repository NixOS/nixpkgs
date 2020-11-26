{ lib, fetchurl, buildDunePackage, ppx_sexp_conv, ppx_cstruct, cstruct
, cstruct-sexp, sexplib, mirage-crypto, mirage-crypto-pk, mirage-crypto-rng
, x509, domain-name, fmt, cstruct-unix, ounit2, ocaml_lwt, ptime
, hacl_x25519, fiat-p256, hkdf, logs, alcotest }:

buildDunePackage rec {
  minimumOCamlVersion = "4.08";

  version = "0.12.6";
  pname = "tls";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-tls/releases/download/v${version}/tls-v${version}.tbz";
    sha256 = "14b2289nhb65qm8wrw51y8qgz5ysn8hcbrj5plznd1pdzl46zxc9";
  };

  useDune2 = true;

  doCheck = true;
  checkInputs = [ cstruct-unix ounit2 alcotest ];

  propagatedBuildInputs = [ ppx_sexp_conv ppx_cstruct cstruct cstruct-sexp
                            sexplib mirage-crypto mirage-crypto-pk mirage-crypto-rng
                            x509 domain-name fmt ocaml_lwt ptime hacl_x25519 fiat-p256
                            hkdf logs ];

  meta = with lib; {
    homepage = "https://github.com/mirleft/ocaml-tls";
    description = "TLS in pure OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
