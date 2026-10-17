{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  liberasurecode,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyeclib";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "pyeclib";
    tag = version;
    hash = "sha256-v7pkV5s10AxU+vgp+gcQF8lJmm6yzDwkqunWuT0zU4c=";
  };

  build-system = [
    setuptools
  ];

  buildInputs = [ liberasurecode ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # The memory usage goes *down* on Darwin, which the test confuses for an increase and fails
    "test_get_metadata_memory_usage"
  ];

  pythonImportsCheck = [ "pyeclib" ];

  meta = {
    description = "This library provides a simple Python interface for implementing erasure codes";
    homepage = "https://github.com/openstack/pyeclib";
    license = lib.licenses.bsd2;
    mainProgram = "pyeclib-backend";
    teams = [ lib.teams.openstack ];
  };
}
