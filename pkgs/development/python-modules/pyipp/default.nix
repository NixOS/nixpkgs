{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, aiohttp, deepmerge, yarl
, aresponses, pytest, pytest-asyncio, pytestcov }:

buildPythonPackage rec {
  pname = "pyipp";
  version = "0.11.0";
  disabled = isPy27;

  src = fetchFromGitHub {
   owner = "ctalkington";
   repo = "python-ipp";
   rev = version;
   sha256 = "0ar3mkyfa9qi3av3885bvacpwlxh420if9ymdj8i4x06ymzc213d";
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
