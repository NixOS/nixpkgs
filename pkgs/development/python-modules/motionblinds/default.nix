{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodomex,
  setuptools,
}:

buildPythonPackage rec {
  pname = "motionblinds";
  version = "0.6.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "motion-blinds";
    tag = version;
    hash = "sha256-gYyPHdOFGWMlXsB0+vBYnAqmEzeHRSKcVtNpedmo0xE=";
  };

  build-system = [ setuptools ];

  dependencies = [ pycryptodomex ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "motionblinds" ];

  meta = {
    description = "Python library for interfacing with Motion Blinds";
    homepage = "https://github.com/starkillerOG/motion-blinds";
    changelog = "https://github.com/starkillerOG/motion-blinds/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
