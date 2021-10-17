{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, aioresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bond-api";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "prystupa";
    repo = "bond-api";
    rev = "v${version}";
    sha256 = "0s7an6kbib1immrbwrh4pzj812zwf8kj3kgky5k3qwxzrj0iv6ak";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bond_api" ];

  meta = with lib; {
    description = "Asynchronous Python wrapper library over Bond Local API";
    homepage = "https://github.com/prystupa/bond-api";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
