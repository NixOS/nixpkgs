{ lib, buildDunePackage, fetchurl, ocaml, alcotest, angstrom, ke }:

buildDunePackage rec {
  pname = "encore";
  version = "0.3";
  src = fetchurl {
    url = "https://github.com/mirage/encore/releases/download/v${version}/encore-v${version}.tbz";
    sha256 = "05nv6yms5axsmq9cspr7884rz5kirj50izx3vdm89q4yl186qykl";
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
