{ lib, buildDunePackage, fetchurl
, ppx_sexp_conv, ppx_cstruct
, mirage-crypto, mirage-crypto-rng, mirage-crypto-pk
, x509, cstruct, cstruct-unix, cstruct-sexp, sexplib, eqaf
, rresult, mtime, logs, fmt, cmdliner, base64, hacl_x25519
, zarith
}:

buildDunePackage rec {
  pname = "awa";
  version = "0.0.5";

  minimumOCamlVersion = "4.07";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/awa-ssh/releases/download/v${version}/awa-${version}.tbz";
    sha256 = "14hqzmikp3hlynhs0wnwj2491106if183swsl7ldk4215a0b7ms4";
  };

  nativeBuildInputs = [ ppx_cstruct ];

  propagatedBuildInputs = [
    mirage-crypto mirage-crypto-rng mirage-crypto-pk x509
    cstruct cstruct-sexp sexplib mtime
    logs base64 hacl_x25519 zarith
    ppx_sexp_conv eqaf
  ];

  doCheck = true;
  checkInputs = [ cstruct-unix cmdliner fmt ];

  meta = with lib; {
    description = "SSH implementation in OCaml";
    homepage = "https://github.com/mirage/awa-ssh";
    changelog = "https://github.com/mirage/awa-ssh/raw/v${version}/CHANGES.md";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    mainProgram = "awa_lwt_server";
  };
}
