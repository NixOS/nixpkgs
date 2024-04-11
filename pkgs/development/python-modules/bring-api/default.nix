{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bring-api";
  version = "0.5.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "miaucl";
    repo = "bring-api";
    rev = "refs/tags/${version}";
    hash = "sha256-vfc4xKLeGF2FuBFwqU99qbkUDBK5Uz66S4F2ODRDPa8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "bring_api"
  ];

  meta = with lib; {
    description = "Module to access the Bring! shopping lists API";
    homepage = "https://github.com/miaucl/bring-api";
    changelog = "https://github.com/miaucl/bring-api/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
