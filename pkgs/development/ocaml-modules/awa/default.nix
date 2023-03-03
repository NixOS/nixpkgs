{ lib, buildDunePackage, fetchurl
, ppx_sexp_conv, ppx_cstruct
, mirage-crypto, mirage-crypto-ec, mirage-crypto-rng, mirage-crypto-pk
, x509, cstruct, cstruct-unix, cstruct-sexp, sexplib, eqaf
, rresult, mtime, logs, fmt, cmdliner, base64
, zarith
}:

buildDunePackage rec {
  pname = "awa";
  version = "0.1.1";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/awa-ssh/releases/download/v${version}/awa-${version}.tbz";
    hash = "sha256-ae1gTx3Emmkof/2Gnhq0d5RyfkFx21hHkVEVgyPdXuo=";
  };

  propagatedBuildInputs = [
    mirage-crypto mirage-crypto-ec mirage-crypto-rng mirage-crypto-pk x509
    cstruct cstruct-sexp sexplib mtime
    logs base64 zarith
    ppx_sexp_conv eqaf
  ];

  buildInputs = [ ppx_cstruct ];

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
