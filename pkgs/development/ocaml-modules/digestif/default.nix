{
  lib,
  ocaml,
  fetchurl,
  buildDunePackage,
  eqaf,
  alcotest,
  astring,
  bos,
  crowbar,
  findlib,
  fpath,
}:

buildDunePackage rec {
  pname = "digestif";
  version = "1.3.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/digestif/releases/download/v${version}/digestif-${version}.tbz";
    hash = "sha256-mmzcszJTnIf0cj/DvXNiayZ1p7EWH98P7TCRhs4Y9Cc=";
  };

  propagatedBuildInputs = [ eqaf ];

  checkInputs = [
    alcotest
    astring
    bos
    crowbar
    fpath
  ];
  doCheck = true;

  postCheck = ''
    ocaml -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib/ test/test_runes.ml
  '';

  meta = {
    description = "Simple hash algorithms in OCaml";
    homepage = "https://github.com/mirage/digestif";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
