{ lib, fetchFromGitHub, buildDunePackage, ocaml, angstrom, faraday, alcotest }:

buildDunePackage rec {
  pname = "httpaf";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    sha256 = "0i2r004ihj00hd97475y8nhjqjln58xx087zcjl0dfp0n7q80517";
  };

  checkInputs = lib.optional doCheck alcotest;
  propagatedBuildInputs = [ angstrom faraday ];
  doCheck = lib.versions.majorMinor ocaml.version != "4.07";

  meta = {
    description = "A high-performance, memory-efficient, and scalable web server for OCaml";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
