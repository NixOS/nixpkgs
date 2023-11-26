{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, aiohttp
, pythonOlder
, pyjwt
}:

buildPythonPackage rec {
  pname = "apple-weatherkit";
  version = "1.0.4";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "tjhorner";
    repo = "python-weatherkit";
    rev = "refs/tags/v${version}";
    hash = "sha256-G/0hyK2rjdSSnVnvAUGyDvsfNMHVgAD7NHfNFmdBCNA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
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
