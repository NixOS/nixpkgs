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
  version = "0.1.11";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rfleming71";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-MlFL8yUCkiMnxPbMGr4jwCs0kYwRM+VGBRQUcQ5Hd6A=";
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
    changelog = "https://github.com/rfleming71/pyoctoprintapi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers= with maintainers; [ hexa ];
  };
}
