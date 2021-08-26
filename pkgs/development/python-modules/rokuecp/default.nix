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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "ctalkington";
    repo = "python-rokuecp";
    rev = version;
    sha256 = "sha256-2FAnshIxaA52EwwwABBQ0sedAsz561YYxXDQo2Vcp1c=";
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
