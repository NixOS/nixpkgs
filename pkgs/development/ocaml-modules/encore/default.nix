{ lib, buildDunePackage, fetchurl, ocaml
, fmt, bigstringaf, bigarray-compat
, bigarray-overlap, angstrom, ke, alcotest }:

buildDunePackage rec {
  pname = "encore";
  version = "0.5";

  src = fetchurl {
    url = "https://github.com/mirage/encore/releases/download/v${version}/encore-v${version}.tbz";
    sha256 = "15n0dla149k9h7migs76wap08z5402qcvxyqxzl887ha6isj3p9n";
  };

  useDune2 = true;

  propagatedBuildInputs = [ angstrom ke fmt bigstringaf bigarray-compat bigarray-overlap ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/encore";
    description = "Library to generate encoder/decoder which ensure isomorphism";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
