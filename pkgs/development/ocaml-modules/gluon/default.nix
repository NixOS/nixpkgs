{ lib
, buildDunePackage
, fetchurl
, bytestring
, config
, libc
, rio
, uri
}:

buildDunePackage rec {
  pname = "gluon";
  version = "0.0.9";

  minimalOCamlVersion = "5.1";

  src = fetchurl {
    url = "https://github.com/riot-ml/gluon/releases/download/${version}/gluon-${version}.tbz";
    hash = "sha256-YWJCPokY1A7TGqCGoxJl14oKDVeMNybEEB7KiK92WSo=";
  };

  buildInputs = [
    config
  ];

  propagatedBuildInputs = [
    bytestring
    libc
    rio
    uri
  ];

  meta = {
    description = "Minimal, portable, and fast API on top of the operating-system's evented I/O API";
    homepage = "https://github.com/riot-ml/gluon";
    changelog = "https://github.com/riot-ml/gluon/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}


