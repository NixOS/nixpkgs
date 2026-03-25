{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  serialio,
  sockio,
}:

buildPythonPackage rec {
  pname = "connio";
  version = "0.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tiagocoutinho";
    repo = "connio";
    tag = "v${version}";
    hash = "sha256-fPM7Ya69t0jpZhKM2MTk6BwjvoW3a8SV3k000LB9Ypo=";
  };

  propagatedBuildInputs = [
    serialio
    sockio
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "connio" ];

  meta = {
    description = "Library for concurrency agnostic communication";
    homepage = "https://github.com/tiagocoutinho/connio";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
