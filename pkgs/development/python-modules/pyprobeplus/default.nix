{
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyprobeplus";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pantherale0";
    repo = "pyprobeplus";
    tag = version;
    hash = "sha256-CJbQs0xZHdXNPX71G1KrrHHV58gXaQsUHGcX9P8E+iY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
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
