{ lib, ocaml, fetchurl, buildDunePackage
, bigarray-compat, eqaf, stdlib-shims
, alcotest, astring, bos, findlib, fpath
}:

buildDunePackage rec {
  pname = "digestif";
  version = "1.0.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/digestif/releases/download/v${version}/digestif-v${version}.tbz";
    sha256 = "11188ya6ksb0p0zvs6saz3qxv4a8pyy8m3sq35f3qfxrxhghqi99";
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
