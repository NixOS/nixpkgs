{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-fullykiosk";
  version = "0.0.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cgarwood";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-GElLaSSr/EEhtjgasP2C79kf+HluVPuQ21I8La7IvLs=";
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
