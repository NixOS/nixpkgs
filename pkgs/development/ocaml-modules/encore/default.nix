{ lib
, buildDunePackage
, fetchurl
, ocaml
, fmt
, bigstringaf
, angstrom
, alcotest
}:

buildDunePackage rec {
  pname = "encore";
  version = "0.8";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/encore/releases/download/v${version}/encore-v${version}.tbz";
    sha256 = "a406bc9863b04bb424692045939d6c170a2bb65a98521ae5608d25b0559344f6";
  };

  useDune2 = true;

  propagatedBuildInputs = [ angstrom fmt bigstringaf ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/encore";
    description = "Library to generate encoder/decoder which ensure isomorphism";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
