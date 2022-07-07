{ lib
, aiohttp
, aresponses
, buildPythonPackage
, deepmerge
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pytest-cov
, yarl
}:

buildPythonPackage rec {
  pname = "pyipp";
  version = "0.11.0";

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
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyipp" ];

  meta = with lib; {
    description = "Asynchronous Python client for Internet Printing Protocol (IPP)";
    homepage = "https://github.com/ctalkington/python-ipp";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
