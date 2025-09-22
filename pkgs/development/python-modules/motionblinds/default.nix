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
  version = "0.6.30";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "motion-blinds";
    tag = version;
    hash = "sha256-xV9od7xTKBBE4f4Mqg57Mp0MXO8/lG+bBKzG+jv6gf4=";
  };

  build-system = [ setuptools ];

  dependencies = [ pycryptodomex ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "motionblinds" ];

  meta = with lib; {
    description = "Python library for interfacing with Motion Blinds";
    homepage = "https://github.com/starkillerOG/motion-blinds";
    changelog = "https://github.com/starkillerOG/motion-blinds/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
