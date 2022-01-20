{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiohwenergy";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DCSBL";
    repo = pname;
    rev = version;
    sha256 = "006q2kgc28dn43skk2x76d13fp51sy073nm8f2hrxn4wqwkccsx3";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aiohwenergy"
  ];

  meta = with lib; {
    description = "Python library to interact with the HomeWizard Energy devices API";
    homepage = "https://github.com/DCSBL/aiohwenergy";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
