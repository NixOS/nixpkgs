{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  serialio,
  sockio,
}:

buildPythonPackage rec {
  pname = "connio";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Library for concurrency agnostic communication";
    homepage = "https://github.com/tiagocoutinho/connio";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
