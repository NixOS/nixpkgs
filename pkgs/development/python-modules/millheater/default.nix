{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "millheater";
  version = "0.4.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pymill";
    rev = version;
    sha256 = "sha256-B9/nxlPHAPZzbOMQj81CxTEjI03JQxfH8F8vy1E4HIQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
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
