{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "homeassistant-bring-api";
  version = "0.5.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "miaucl";
    repo = "homeassistant-bring-api";
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
    "homeassistant_bring_api"
  ];

  meta = with lib; {
    description = "Module to access the Bring! shopping lists API with Home Assistant";
    homepage = "https://github.com/miaucl/homeassistant-bring-api";
    changelog = "https://github.com/miaucl/homeassistant-bring-api/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
