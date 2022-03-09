{ lib
, aiohttp
, aresponses
, awesomeversion
, backoff
, buildPythonPackage
, cachetools
, fetchFromGitHub
, poetry
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, xmltodict
, yarl
}:

buildPythonPackage rec {
  pname = "rokuecp";
  version = "0.15.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ctalkington";
    repo = "python-rokuecp";
    rev = version;
    hash = "sha256-yNmnCoHIBlpQCLd+YcsKCKd1wWh8WZNpILWmChZGWH4=";
  };

  nativeBuildInputs = [
    # Requires poetry not poetry-core
    poetry
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
    cachetools
    xmltodict
    awesomeversion
    yarl
  ];

  checkInputs = [
    aresponses
    pytestCheckHook
    pytest-asyncio
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov" ""
  '';

  disabledTests = [
    # https://github.com/ctalkington/python-rokuecp/issues/249
    "test_resolve_hostname"
    # Assertion issue
    "test_guess_stream_format"
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
