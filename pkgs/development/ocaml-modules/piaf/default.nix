{ alcotest-lwt
, buildDunePackage
, ocaml
, bigarray-compat
, dune-site
, fetchurl
, gluten-lwt-unix
, lib
, logs
, magic-mime
, mrmime
, psq
, rresult
, uri
}:

lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "piaf is not available for OCaml ${ocaml.version}"

buildDunePackage rec {
  pname = "piaf";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/anmonteiro/piaf/releases/download/${version}/piaf-${version}.tbz";
    hash = "sha256-AMO+ptGox33Bi7u/H0SaeCU88XORrRU3UbLof3EwcmU=";
  };

  postPatch = ''
    substituteInPlace ./vendor/dune --replace "mrmime.prettym" "prettym"
  '';

  propagatedBuildInputs = [
    bigarray-compat
    logs
    magic-mime
    mrmime
    psq
    rresult
    uri
    gluten-lwt-unix
  ];

  nativeCheckInputs = [
    alcotest-lwt
    dune-site
  ];
  # Check fails with OpenSSL 3
  doCheck = false;

  meta = {
    description = "HTTP library with HTTP/2 support written entirely in OCaml";
    homepage = "https://github.com/anmonteiro/piaf";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ anmonteiro ];
  };
}
