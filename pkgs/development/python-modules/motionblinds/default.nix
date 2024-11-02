{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodomex,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "motionblinds";
  version = "0.6.25";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "motion-blinds";
    rev = "refs/tags/${version}";
    hash = "sha256-MU+zMka8d8wocc90vdS56BMHg6Z/LAAdRetiysh9Ssc=";
  };

  build-system = [ setuptools ];

  dependencies = [ pycryptodomex ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "motionblinds" ];

  meta = with lib; {
    description = "Python library for interfacing with Motion Blinds";
    homepage = "https://github.com/starkillerOG/motion-blinds";
    changelog = "https://github.com/starkillerOG/motion-blinds/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
