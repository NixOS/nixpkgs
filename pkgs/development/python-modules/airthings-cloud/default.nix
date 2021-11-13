{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "airthings-cloud";
  version = "0.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyAirthings";
    rev = version;
    sha256 = "08cbysx5p9k8hzr6sdykx91j0gx8x15b8807338dsl3qx8nhfb8j";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "airthings" ];

  meta = with lib; {
    description = "Python module for Airthings";
    homepage = "https://github.com/Danielhiversen/pyAirthings";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
