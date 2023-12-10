{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, aiohttp
, aiohttp-retry
, pythonOlder
, pyjwt
}:

buildPythonPackage rec {
  pname = "apple-weatherkit";
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "tjhorner";
    repo = "python-weatherkit";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZwHomiRkoV2Oi5c7qgTOKdu6R8dFfiVBi5XQMxrQvIU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    aiohttp-retry
    pyjwt
  ] ++ pyjwt.optional-dependencies.crypto;

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "apple_weatherkit"
  ];

  meta = with lib; {
    description = "Python library for Apple WeatherKit";
    homepage = "https://github.com/tjhorner/python-weatherkit";
    changelog = "https://github.com/tjhorner/python-weatherkit/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
