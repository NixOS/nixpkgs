{ lib, fetchFromGitLab, buildDunePackage, hex, uri }:

buildDunePackage rec {
  pname = "json-data-encoding";
  version = "1.0.1";
  minimalOCamlVersion = "4.10";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "data-encoding";
    rev = "v${version}";
    hash = "sha256-KoA4xX4tNyi6bX5kso/Wof1LA7431EXJ34eD5X4jnd8=";
  };

  propagatedBuildInputs = [
    hex
    uri
  ];

  meta = {
    homepage = "https://gitlab.com/nomadic-labs/json-data-encoding";
    description = "Type-safe encoding to and decoding from JSON";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
