{ lib, buildDunePackage, fetchurl, ocaml, alcotest, angstrom, ke }:

buildDunePackage rec {
  pname = "encore";
  version = "0.4";
  src = fetchurl {
    url = "https://github.com/mirage/encore/releases/download/v${version}/encore-v${version}.tbz";
    sha256 = "1qknpz9rlkxny48gq5qv1fzglnkparyv8gmz3331zah0c3jgj051";
  };
  propagatedBuildInputs = [ angstrom ke ];
  checkInputs = lib.optional doCheck alcotest;
  doCheck = lib.versions.majorMinor ocaml.version != "4.07";

  meta = {
    homepage = "https://github.com/mirage/encore";
    description = "Library to generate encoder/decoder which ensure isomorphism";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
