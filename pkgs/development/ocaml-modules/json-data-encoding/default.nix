{ lib, fetchFromGitLab, buildDunePackage, uri, crowbar, alcotest }:

buildDunePackage rec {
  pname = "json-data-encoding";
  version = "0.12.1";
  minimalOCamlVersion = "4.10";
  duneVersion = "3";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "json-data-encoding";
    rev = version;
    hash = "sha256-ticulOKiFNQIZNFOQE9UQOw/wqRfygQwLVIc4kkmwg4=";
  };

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
