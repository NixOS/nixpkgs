{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynmeagps";
  version = "1.0.57";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "semuconsulting";
    repo = "pynmeagps";
    tag = "v${version}";
    hash = "sha256-aFB0L2d/2LzDCS5ZbY1/NetDdiuGiwrgqlDyCAv6lV0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "pynmeagps" ];

  meta = {
    description = "NMEA protocol parser and generator";
    homepage = "https://github.com/semuconsulting/pynmeagps";
    changelog = "https://github.com/semuconsulting/pynmeagps/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dylan-gonzalez ];
  };
}
