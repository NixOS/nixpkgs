{ lib, buildDunePackage, fetchurl
, ppx_sexp_conv, ppx_cstruct
, mirage-crypto, mirage-crypto-rng, mirage-crypto-pk
, x509, cstruct, cstruct-unix, cstruct-sexp, sexplib
, rresult, mtime, logs, fmt, cmdliner, base64, hacl_x25519
, zarith
}:

buildDunePackage rec {
  pname = "awa";
  version = "0.0.4";

  minimumOCamlVersion = "4.07";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/awa-ssh/releases/download/v${version}/awa-v${version}.tbz";
    sha256 = "1l7nsd8jifxjq78xyzcc0z9igc02m2qlvv4cxzsgdim6n1jfzxj2";
  };

  nativeBuildInputs = [ ppx_sexp_conv ppx_cstruct ];

  propagatedBuildInputs = [
    mirage-crypto mirage-crypto-rng mirage-crypto-pk x509
    cstruct cstruct-sexp sexplib mtime
    logs base64 hacl_x25519 zarith
  ];

  doCheck = true;
  checkInputs = [ cstruct-unix cmdliner fmt ];

  meta = with lib; {
    description = "SSH implementation in OCaml";
    license = licenses.isc;
    homepage = "https://github.com/mirage/awa-ssh";
    changelog = "https://github.com/mirage/awa-ssh/raw/v${version}/CHANGES.md";
    maintainers = [ maintainers.sternenseemann ];
  };
}
