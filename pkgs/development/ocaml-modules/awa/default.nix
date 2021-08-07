{ lib, buildDunePackage, fetchurl
, ppx_sexp_conv, ppx_cstruct
, mirage-crypto, mirage-crypto-rng, mirage-crypto-pk
, x509, cstruct, cstruct-unix, cstruct-sexp, sexplib
, rresult, mtime, logs, fmt, cmdliner, base64, hacl_x25519
, zarith
}:

buildDunePackage rec {
  pname = "awa";
  version = "0.0.3";

  minimumOCamlVersion = "4.07";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/awa-ssh/releases/download/v${version}/awa-v${version}.tbz";
    sha256 = "5a7927363ffe672cccf12d5425386e84f6f553a17ffec2b01ae5dc28180c831a";
  };

  nativeBuildInputs = [ ppx_sexp_conv ppx_cstruct ];

  propagatedBuildInputs = [
    mirage-crypto mirage-crypto-rng mirage-crypto-pk x509
    cstruct cstruct-sexp sexplib rresult mtime
    logs base64 hacl_x25519 zarith
  ];

  doCheck = true;
  checkInputs = [ cstruct-unix cmdliner fmt ];

  meta = with lib; {
    description = "SSH implementation in OCaml";
    license = licenses.isc;
    homepage = "https://github.com/mirage/awa-ssh";
    maintainers = [ maintainers.sternenseemann ];
  };
}
