{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "aiohwenergy";
  version = "0.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "DCSBL";
    repo = "aiohwenergy";
    rev = version;
    hash = "sha256-WfkwIxyDzLNzhWNWST/V3iN9Bhu2oXDwGiA5UXCq5ho=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiohwenergy" ];

  meta = with lib; {
    description = "Python library to interact with the HomeWizard Energy devices API";
    homepage = "https://github.com/DCSBL/aiohwenergy";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
