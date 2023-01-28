{ lib, buildDunePackage, fetchurl
, ppx_sexp_conv, ppx_cstruct
, mirage-crypto, mirage-crypto-ec, mirage-crypto-rng, mirage-crypto-pk
, x509, cstruct, cstruct-unix, cstruct-sexp, sexplib, eqaf
, rresult, mtime, logs, fmt, cmdliner, base64
, zarith
}:

buildDunePackage rec {
  pname = "awa";
  version = "0.1.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/awa-ssh/releases/download/v${version}/awa-${version}.tbz";
    sha256 = "sha256-aPnFDp52oYVHr/56lFw0gtVJ0KvHawyM5FGtpHPOVY8=";
  };

  nativeBuildInputs = [ ppx_cstruct ];

  propagatedBuildInputs = [
    mirage-crypto mirage-crypto-ec mirage-crypto-rng mirage-crypto-pk x509
    cstruct cstruct-sexp sexplib mtime
    logs base64 zarith
    ppx_sexp_conv eqaf
  ];

  doCheck = true;
  nativeCheckInputs = [ cstruct-unix cmdliner fmt ];

  meta = with lib; {
    description = "SSH implementation in OCaml";
    homepage = "https://github.com/mirage/awa-ssh";
    changelog = "https://github.com/mirage/awa-ssh/raw/v${version}/CHANGES.md";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
