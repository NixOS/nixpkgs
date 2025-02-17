{
  ahocorapy,
  buildPythonPackage,
  construct,
  fetchFromGitHub,
  lib,
  pybluez,
  pytestCheckHook,
  setuptools,
  stdenv,
}:

buildPythonPackage rec {
  pname = "beacontools";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "citruz";
    repo = "beacontools";
    tag = "v${version}";
    hash = "sha256-3a/HDssOqIfReSijRvmiXwuZjvWLJfDaDyUdA2vv/jA=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "ahocorapy"
  ];

  dependencies = [
    ahocorapy
    construct
  ];

  optional-dependencies = {
    scan = lib.optionals stdenv.hostPlatform.isLinux [ pybluez ];
  };

  pythonImportsCheck = [ "beacontools" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/citruz/beacontools/releases/tag/${src.tag}";
    description = "Python library for working with various types of Bluetooth LE Beacons";
    homepage = "https://github.com/citruz/beacontools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
