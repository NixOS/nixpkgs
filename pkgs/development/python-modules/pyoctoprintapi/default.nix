{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools

# propagated
, aiohttp

# tests
, pytest-asyncio
, pytestCheckHook
}:

let
  pname = "pyoctoprintapi";
  version = "0.1.14";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rfleming71";
    repo = "pyoctoprintapi";
    rev = "refs/tags/v${version}";
    hash = "sha256-DKqkT0Wyxf4grXBqei9IYBGMOgPxjzuo955M/nHDLo8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  pythonImportsCheck = [
    "pyoctoprintapi"
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Simple async wrapper around the Octoprint API";
    homepage = "https://github.com/rfleming71/pyoctoprintapi";
    changelog = "https://github.com/rfleming71/pyoctoprintapi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers= with maintainers; [ hexa ];
  };
}
