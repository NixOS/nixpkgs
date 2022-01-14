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
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ctalkington";
    repo = "python-rokuecp";
    rev = version;
    sha256 = "08cxqm8m39wwprcnhmyfq7aj1wxkzq7rq5lzsaw1p3lrzgif1mxr";
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
