{
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyprobeplus";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pantherale0";
    repo = "pyprobeplus";
    tag = version;
    hash = "sha256-ixrkwnvqjHwqnKG3Xo4qJP/FcP7fuAOPKpar13e8U1w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
  ];

  pythonImportsCheck = [ "pyprobeplus" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/pantherale0/pyprobeplus/releases/tag/${src.tag}";
    description = "Generic library to interact with a Probe Plus BLE device";
    homepage = "https://github.com/pantherale0/pyprobeplus";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
