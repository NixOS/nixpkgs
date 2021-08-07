{ lib
, buildPythonPackage
, fetchFromGitHub
, aiofiles
, aiohttp
, async_generator
, pypubsub
, pyserial
, pyserial-asyncio
, pyyaml
, pytestCheckHook
, pythonOlder
, pytest-cov
, pytest-asyncio
, pytest-timeout
}:

buildPythonPackage rec {
  pname = "pyinsteon";
  version = "1.0.12";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-IlRCUogs78kbKY8gp22YzIkNrXhSCLJDDDtFAucrQxE=";
  };

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    async_generator
    pypubsub
    pyserial
    pyserial-asyncio
    pyyaml
  ];

  checkInputs = [
    pytest-asyncio
    pytest-cov
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyinsteon" ];

  meta = with lib; {
    description = "Python library to support Insteon home automation projects";
    longDescription = ''
      This is a Python package to interface with an Insteon Modem. It has been
      tested to work with most USB or RS-232 serial based devices such as the
      2413U, 2412S, 2448A7 and Hub models 2242 and 2245.
    '';
    homepage = "https://github.com/pyinsteon/pyinsteon";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
