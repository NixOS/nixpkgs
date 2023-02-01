{ lib
, buildPythonPackage
, fetchPypi
, certifi
, loguru
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiospamc";
  version = "0.9.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MwAIUAM2AgQ9OiRCboOUI2dJf29mQcZRXtlBIhdshD8=";
  };

  propagatedBuildInputs = [
    certifi
    loguru
  ];

  pythonImportsCheck = [
    "aiospamc"
  ];

  meta = with lib; {
    description = "Python asyncio-based library that implements the SPAMC/SPAMD client protocol used by SpamAssassin";
    homepage = "https://aiospamc.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
  };
}
