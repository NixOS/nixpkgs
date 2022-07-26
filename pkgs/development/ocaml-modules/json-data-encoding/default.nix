{ lib, fetchFromGitLab, buildDunePackage, uri, crowbar, alcotest }:

buildDunePackage rec {
  pname = "json-data-encoding";
  version = "0.11";
  minimalOCamlVersion = "4.10";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "json-data-encoding";
    rev = "${version}";
    sha256 = "sha256-4FNUU82sq3ylgw0lxHlwi1OV58NRRh9zJqE47YyQZSc=";
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
