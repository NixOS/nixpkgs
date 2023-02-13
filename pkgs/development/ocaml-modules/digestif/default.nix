{ lib, ocaml, fetchurl, buildDunePackage
, pkg-config, which
, eqaf
, alcotest, astring, bos, findlib, fpath
}:

buildDunePackage rec {
  pname = "digestif";
  version = "1.1.2";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/digestif/releases/download/v${version}/digestif-${version}.tbz";
    sha256 = "sha256-edNM5ROxFIV+OAqr328UcyGPGwXdflHQOJB3ntAbRmY=";
  };

  nativeBuildInputs = [ findlib which ocaml pkg-config ];

  propagatedBuildInputs = [ eqaf ];

  checkInputs = [ alcotest astring bos fpath ];
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
