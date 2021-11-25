{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, xmltodict
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rokuecp";
  version = "0.8.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ctalkington";
    repo = "python-rokuecp";
    rev = version;
    sha256 = "sha256-vwXBYwiDQZBxEZDwLX9if6dt7tKQQOLyKL5m0q/3eUw=";
  };

  propagatedBuildInputs = [
    aiohttp
    xmltodict
    yarl
  ];

  checkInputs = [
    aresponses
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "rokuecp"
  ];

  meta = with lib; {
    description = "Asynchronous Python client for Roku (ECP)";
    homepage = "https://github.com/ctalkington/python-rokuecp";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
