{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  btlewrap,
  bluepy,
}:

buildPythonPackage rec {
  pname = "beewi-smartclim";
  version = "0.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alemuro";
    repo = "beewi_smartclim";
    tag = version;
    hash = "sha256-xdr545Q4DFhup2BCMZZ1WYWgt97qT6oipIHWcsp90+A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    btlewrap
    bluepy
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [ "beewi_smartclim" ];

  meta = {
    description = "Library to read data from BeeWi SmartClim sensor using Bluetooth LE";
    homepage = "https://github.com/alemuro/beewi_smartclim";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
