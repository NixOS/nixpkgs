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
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "prystupa";
    repo = "bond-api";
    rev = "v${version}";
    sha256 = "0zqaqqadr4x4vmq28nfk5x67gfwqqfy19z0cgrpxlbbvxamccym0";
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
