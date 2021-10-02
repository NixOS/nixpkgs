{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "open-garage";
  version = "0.1.5";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyOpenGarage";
    rev = version;
    sha256 = "1iqcqkbb1ik5lmsvwgy6i780x6y3wlm1gx257anxyvp1b21gm24p";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "opengarage" ];

  meta = with lib; {
    description = "Python module to communicate with opengarage.io";
    homepage = "https://github.com/Danielhiversen/pyOpenGarage";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
