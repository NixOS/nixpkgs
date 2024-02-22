{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "rova";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "GidoHakvoort";
    repo = "rova";
    rev = "refs/tags/v${version}";
    hash = "sha256-6tICjph+ffS6OSMxzR4ANB4Q6sG1AKAgUN83DyEGpvo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
    changelog = "https://github.com/GidoHakvoort/rova/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
