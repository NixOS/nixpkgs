{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "rova";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "GidoHakvoort";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6tICjph+ffS6OSMxzR4ANB4Q6sG1AKAgUN83DyEGpvo=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "rova"
  ];

  meta = with lib; {
    description = "Module to access for ROVA calendars";
    homepage = "https://github.com/GidoHakvoort/rova";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
