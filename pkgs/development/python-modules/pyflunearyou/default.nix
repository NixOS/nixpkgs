{ lib
, aiohttp
, aresponses
, aiocache
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, msgpack
, ujson
}:

buildPythonPackage rec {
  pname = "pyflunearyou";
  version = "2021.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-Q65OSE4qckpvaIvZULBR434i7hwuVM97eSq1Blb1oIU=";
  };

  pythonRelaxDeps = [
    "aiocache"
    "ujson"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    aiohttp
    aiocache
    msgpack
    ujson
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-aiohttp
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_.
    "examples/"
  ];

  pythonImportsCheck = [
    "pyflunearyou"
  ];

  meta = with lib; {
    description = "Python library for retrieving UV-related information from Flu Near You";
    homepage = "https://github.com/bachya/pyflunearyou";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
