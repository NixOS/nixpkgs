{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, xmltodict
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rokuecp";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "ctalkington";
    repo = "python-rokuecp";
    rev = version;
    sha256 = "02mbmwljcvqj3ksj2irdm8849lcxzwa6fycgjqb0i75cgidxpans";
  };

  propagatedBuildInputs = [
    aiohttp
    xmltodict
    yarl
  ];

  checkInputs = [
    aresponses
    pytestCheckHook
    pytest-asyncio
  ];

  meta = with lib; {
    description = "Asynchronous Python client for Roku (ECP)";
    homepage = "https://github.com/ctalkington/python-rokuecp";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
