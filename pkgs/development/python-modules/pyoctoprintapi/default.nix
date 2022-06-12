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
  version = "0.1.8";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rfleming71";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TeMgEwKVZd0gq8J0kYsg0/v6A2BVTOE0/VmyiyrjV5c=";
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
