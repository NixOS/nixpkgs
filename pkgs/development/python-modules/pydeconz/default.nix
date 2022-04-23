{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pydeconz";
  version = "90";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "deconz";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-DojTqgv3Dr+th2n/gPM70r/5QE487OgyYOBVxVzvcXE=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aioresponses
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pydeconz"
  ];

  meta = with lib; {
    description = "Python library wrapping the Deconz REST API";
    homepage = "https://github.com/Kane610/deconz";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
