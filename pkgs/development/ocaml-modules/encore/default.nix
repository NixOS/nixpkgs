{ lib, buildDunePackage, fetchurl, ocaml
, fmt, bigstringaf, angstrom, alcotest }:

buildDunePackage rec {
  pname = "encore";
  version = "0.7";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/encore/releases/download/v${version}/encore-v${version}.tbz";
    sha256 = "0cwmhkj5jmk3z5y0agmkf5ygpgxynjkq2d7d50jgzmnqs7f6g7nh";
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
