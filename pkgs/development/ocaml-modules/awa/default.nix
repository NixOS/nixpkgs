{ lib, buildDunePackage, fetchurl
, ppx_sexp_conv
, mirage-crypto, mirage-crypto-ec, mirage-crypto-rng, mirage-crypto-pk
, x509, cstruct, cstruct-unix, cstruct-sexp, sexplib, eqaf-cstruct
, mtime, logs, fmt, cmdliner, base64
, zarith
}:

buildDunePackage rec {
  pname = "awa";
  version = "0.3.1";

  minimalOCamlVersion = "4.10";

  src = fetchurl {
    url = "https://github.com/mirage/awa-ssh/releases/download/v${version}/awa-${version}.tbz";
    hash = "sha256-VejHFn07B/zoEG4LjLaen24ig9kAXtERl/pRo6UZCQk=";
  };

  postPatch = ''
    substituteInPlace lib/dune --replace-warn eqaf.cstruct eqaf-cstruct
  '';

  propagatedBuildInputs = [
    mirage-crypto mirage-crypto-ec mirage-crypto-rng mirage-crypto-pk x509
    cstruct cstruct-sexp sexplib mtime
    logs base64 zarith
    ppx_sexp_conv eqaf-cstruct
  ];

  doCheck = true;
  checkInputs = [ cstruct-unix cmdliner fmt ];

  meta = with lib; {
    description = "SSH implementation in OCaml";
    homepage = "https://github.com/mirage/awa-ssh";
    changelog = "https://github.com/mirage/awa-ssh/raw/v${version}/CHANGES.md";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
