{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "heatzypy";
  version = "2.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Cyr-ius";
    repo = pname;
    rev = version;
    sha256 = "sha256-sD32zP3HWEq9FCM9PFywHaLEU+MJOvro+FpjrlM4dG4=";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "heatzypy"
  ];

  meta = with lib; {
    description = "Python module to interact with Heatzy devices";
    homepage = "https://github.com/Cyr-ius/heatzypy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
