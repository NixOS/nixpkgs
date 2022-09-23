{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiohwenergy";
  version = "0.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DCSBL";
    repo = pname;
    rev = version;
    sha256 = "sha256-WfkwIxyDzLNzhWNWST/V3iN9Bhu2oXDwGiA5UXCq5ho=";
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
