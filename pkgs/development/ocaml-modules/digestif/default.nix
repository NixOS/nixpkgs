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
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/mirage/digestif/releases/download/v${finalAttrs.version}/digestif-${finalAttrs.version}.tbz";
    hash = "sha256-mmzcszJTnIf0cj/DvXNiayZ1p7EWH98P7TCRhs4Y9Cc=";
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
