{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, xmltodict
, yarl
}:

buildPythonPackage rec {
  pname = "rokuecp";
  version = "0.8.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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

  disabledTests = [
    # https://github.com/ctalkington/python-rokuecp/issues/249
    "test_resolve_hostname"
  ];

  pythonImportsCheck = [
    "rokuecp"
  ];

  meta = with lib; {
    description = "Asynchronous Python client for Roku (ECP)";
    homepage = "https://github.com/ctalkington/python-rokuecp";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
