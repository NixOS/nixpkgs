{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  bleak,
  bleak-retry-connector,
}:

buildPythonPackage rec {
  pname = "hueble";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flip-dots";
    repo = "HueBLE";
    tag = "v${version}";
    hash = "sha256-CMipY44tfuOQE2P77mH44stevg1IOd0MeF+cS6jkPnw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  pythonImportsCheck = [ "HueBLE" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/flip-dots/HueBLE/blob/${src.tag}/CHANGELOG.rst";
    description = "Python module for controlling Bluetooth Philips Hue lights";
    homepage = "https://github.com/flip-dots/HueBLE";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
