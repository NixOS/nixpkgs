{ lib, fetchFromGitLab, buildDunePackage, uri, crowbar, alcotest }:

buildDunePackage rec {
  pname = "json-data-encoding";
  version = "0.10";
  minimalOCamlVersion = "4.10";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "json-data-encoding";
    rev = "${version}";
    sha256 = "0m0xx382wr44wz7gxf7mpfjx2w287pvqhg2lfvzmclfq3y5iy6mx";
  };
  useDune2 = true;

  propagatedBuildInputs = [
    uri
  ];

  checkInputs = [
    crowbar
    alcotest
  ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/nomadic-labs/json-data-encoding";
    description = "Type-safe encoding to and decoding from JSON";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
