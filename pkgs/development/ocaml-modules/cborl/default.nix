{
  lib,
  buildDunePackage,
  fetchFromCodeberg,
  nix-update-script,
  fmt,
  zarith,
  alcotest,
  qcheck,
  qcheck-alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "cborl";
  version = "0.1.0";

  minimalOCamlVersion = "4.14";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "openEngiadina";
    repo = "ocaml-cborl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MXSZgab1gMTyQKKi+odvM0yJQc2pa0Fw0p1fLJAefJU=";
  };

  propagatedBuildInputs = [
    fmt
    zarith
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    qcheck
    qcheck-alcotest
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of the Concise Binary Object Representation (CBOR) as specified by RFC 8949 for OCaml";
    homepage = "https://codeberg.org/openengiadina/ocaml-cborl";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
