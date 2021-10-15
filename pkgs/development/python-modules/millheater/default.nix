
{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "millheater";
  version = "0.6.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pymill";
    rev = version;
    sha256 = "sha256-CG0hQN4m8EE+j5yUqODJX8/DLTVWS9tSPADSDHl6K9o=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    cryptography
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "mill" ];

  meta = with lib; {
    description = "Python library for Mill heater devices";
    homepage = "https://github.com/Danielhiversen/pymill";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
