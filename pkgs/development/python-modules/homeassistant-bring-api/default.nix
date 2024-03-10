{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "homeassistant-bring-api";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "miaucl";
    repo = "homeassistant-bring-api";
    rev = "refs/tags/${version}";
    hash = "sha256-EQ1Qv4B7axwERKvuMnLizpfA6jRNf/SyB6ktQ2BjFtM=";
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
