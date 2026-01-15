{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "python-fullykiosk";
  version = "0.0.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cgarwood";
    repo = "python-fullykiosk";
    tag = version;
    hash = "sha256-+JBgBi05zNgIt2cXlHjFPI6nBFR7SpMCWIQHKtnZeX4=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "fullykiosk" ];

  meta = {
    description = "Wrapper for Fully Kiosk Browser REST interface";
    homepage = "https://github.com/cgarwood/python-fullykiosk";
    changelog = "https://github.com/cgarwood/python-fullykiosk/releases/tag/${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
