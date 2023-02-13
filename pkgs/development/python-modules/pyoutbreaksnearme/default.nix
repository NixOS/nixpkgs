{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, ujson
}:

buildPythonPackage rec {
  pname = "pyoutbreaksnearme";
  version = "2022.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-D7oXkKDSg+yF+j1WyG/VVY12hLU6oyhEtxLrF6IkMSA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
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
    "pyoutbreaksnearme"
  ];

  meta = with lib; {
    description = "Library for retrieving data from for Outbreaks Near Me";
    homepage = "https://github.com/bachya/pyoutbreaksnearme";
    changelog = "https://github.com/bachya/pyoutbreaksnearme/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
