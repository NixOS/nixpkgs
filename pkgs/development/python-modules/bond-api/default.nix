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
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "prystupa";
    repo = "bond-api";
    rev = "v${version}";
    sha256 = "1zkwgkq9lqck60p70lwr3msv8bjwln6f5gxv1wjd80liga9gk32j";
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
