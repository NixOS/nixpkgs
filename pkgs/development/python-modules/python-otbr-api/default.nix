{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, voluptuous
}:

buildPythonPackage rec {
  pname = "python-otbr-api";
  version = "1.0.4";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-p1s0EGCNcwSIYT/+kV0HzjGOEimWnARYDYX3eDlMHEk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    voluptuous
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "python_otbr_api"
  ];

  meta = with lib; {
    description = "Library for the Open Thread Border Router";
    homepage = "https://github.com/home-assistant-libs/python-otbr-api";
    changelog = "https://github.com/home-assistant-libs/python-otbr-api/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
