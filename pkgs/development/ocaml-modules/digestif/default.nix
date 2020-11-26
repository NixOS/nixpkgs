{ lib, ocaml, fetchurl, buildDunePackage
, bigarray-compat, eqaf, stdlib-shims
, alcotest, astring, bos, findlib, fpath
}:

buildDunePackage rec {
  pname = "digestif";
  version = "0.9.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/digestif/releases/download/v${version}/digestif-v${version}.tbz";
    sha256 = "0vk9prgjp46xs8qizq7szkj6mqjj2ymncs2016bc8zswcdc1a3q4";
  };

  propagatedBuildInputs = [ bigarray-compat eqaf stdlib-shims ];

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
