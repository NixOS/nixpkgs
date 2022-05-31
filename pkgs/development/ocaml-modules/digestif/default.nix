{ lib, ocaml, fetchurl, buildDunePackage
, pkg-config, which
, bigarray-compat, eqaf, stdlib-shims
, alcotest, astring, bos, findlib, fpath
}:

buildDunePackage rec {
  pname = "digestif";
  version = "1.1.2";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/digestif/releases/download/v${version}/digestif-${version}.tbz";
    sha256 = "sha256-edNM5ROxFIV+OAqr328UcyGPGwXdflHQOJB3ntAbRmY=";
  };

  nativeBuildInputs = [ findlib which ];
  buildInputs = [ ocaml ];

  propagatedBuildInputs = [ bigarray-compat eqaf stdlib-shims ];

  strictDeps = !doCheck;

  checkInputs = [ alcotest astring bos fpath ];
  doCheck = lib.versionAtLeast ocaml.version "4.05";

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
