{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mill-local";
  version = "0.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyMillLocal";
    rev = version;
    sha256 = "sha256-OKaR0hpNVBlaZrEmEmHxqRG1i03XP2Z4c7c35YIqe+I=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "mill_local"
  ];

  meta = with lib; {
    description = "Python module to communicate locally with Mill heaters";
    homepage = "https://github.com/Danielhiversen/pyMillLocal";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
