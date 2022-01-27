{ lib
, aiohttp
, aresponses
, buildPythonPackage
, cachetools
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, xmltodict
, yarl
}:

buildPythonPackage rec {
  pname = "rokuecp";
  version = "0.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ctalkington";
    repo = "python-rokuecp";
    rev = version;
    sha256 = "sha256-Y4Ge7IOR7//MJ0w7kdOgchLWFGR1qJbY0PSpJrjucaQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    cachetools
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
