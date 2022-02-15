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
  version = "0.13.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ctalkington";
    repo = "python-rokuecp";
    rev = version;
    hash = "sha256-TWjONAGUwcCaWiaCxgR1xV1R+Ouy7FvMUewZa3z1mBc=";
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
