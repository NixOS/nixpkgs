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
  version = "0.1.7";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rfleming71";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XAMHQ7n03e10hFcPIUqyCDlRk2uO8dX8Iq0mdY7wRGE=";
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
