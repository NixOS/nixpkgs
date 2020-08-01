{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, aiohttp, deepmerge, yarl
, aresponses, pytest, pytest-asyncio, pytestcov }:

buildPythonPackage rec {
  pname = "pyipp";
  version = "0.10.1";
  disabled = isPy27;

  src = fetchFromGitHub {
   owner = "ctalkington";
   repo = "python-ipp";
   rev = version;
   sha256 = "0y9mkrx66f4m77jzfgdgmvlqismvimb6hm61j2va7zapm8dyabvr";
  };

  propagatedBuildInputs = [
    aiohttp
    deepmerge
    yarl
  ];

  checkInputs = [
    aresponses
    pytest
    pytest-asyncio
    pytestcov
  ];

  checkPhase = ''
    pytest -q .
  '';

  meta = with lib; {
    description = "Asynchronous Python client for Internet Printing Protocol (IPP)";
    homepage = "https://github.com/ctalkington/python-ipp";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
