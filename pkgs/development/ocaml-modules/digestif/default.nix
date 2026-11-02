{
  lib,
  ocaml,
  fetchurl,
  buildDunePackage,
  eqaf,
  alcotest,
  crowbar,
}:

buildDunePackage (finalAttrs: {
  pname = "digestif";
  version = "1.4.1";

  src = fetchurl {
    url = "https://github.com/mirage/digestif/releases/download/v${finalAttrs.version}/digestif-${finalAttrs.version}.tbz";
    hash = "sha256-2amLFiGWUd7965lsedGr7tOv8wm6wDlMmPkfog8rjvk=";
  };

  propagatedBuildInputs = [ eqaf ];

  checkInputs = [
    alcotest
    crowbar
  ];
  doCheck = true;

  meta = {
    description = "Simple hash algorithms in OCaml";
    homepage = "https://github.com/mirage/digestif";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
