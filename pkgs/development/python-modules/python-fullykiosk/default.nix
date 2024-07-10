{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-fullykiosk";
  version = "0.0.14";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cgarwood";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-+JBgBi05zNgIt2cXlHjFPI6nBFR7SpMCWIQHKtnZeX4=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "fullykiosk" ];

  meta = with lib; {
    description = "Wrapper for Fully Kiosk Browser REST interface";
    homepage = "https://github.com/cgarwood/python-fullykiosk";
    changelog = "https://github.com/cgarwood/python-fullykiosk/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
