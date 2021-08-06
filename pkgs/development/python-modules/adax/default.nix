{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "adax";
  version = "0.1.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyadax";
    rev = version;
    sha256 = "06qk8xbv8lsaabdpi6pclnbkp3vmb4k18spahldazqj8235ii237";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "adax" ];

  meta = with lib; {
    description = "Python module to communicate with Adax";
    homepage = "https://github.com/Danielhiversen/pyAdax";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
