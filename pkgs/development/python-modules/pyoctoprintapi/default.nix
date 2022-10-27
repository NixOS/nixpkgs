{ lib
, buildPythonPackage
, fetchFromGitHub

# propagated
, aiohttp

# tests
, pytest-asyncio
, pytestCheckHook
}:

let
  pname = "pyoctoprintapi";
  version = "0.1.9";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rfleming71";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kZMTHw0S12aUn/DYQuyjQa48QtiwLGYyY4gYKA5063A=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  pythonImportsCheck = [
    "pyoctoprintapi"
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Simple async wrapper around the Octoprint API";
    homepage = "https://github.com/rfleming71/pyoctoprintapi";
    license = licenses.mit;
    maintainers= with maintainers; [ hexa ];
  };
}
