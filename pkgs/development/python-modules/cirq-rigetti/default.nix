{
  lib,
  buildPythonPackage,
  cirq-core,
  fetchpatch2,
  pyquil,
  pytestCheckHook,
  pythonOlder,
  qcs-sdk-python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cirq-rigetti";
  pyproject = true;
  inherit (cirq-core) version src;

  disabled = pythonOlder "3.10";

  patches = [
    # https://github.com/quantumlib/Cirq/pull/6734
    (fetchpatch2 {
      name = "fix-rigetti-check-for-aspen-family-device-kind.patch";
      url = "https://github.com/quantumlib/Cirq/commit/dd395fb71fb7f92cfd34f008bf2a98fc70b57fae.patch";
      stripLen = 1;
      hash = "sha256-EWB2CfMS2+M3zNFX5PwFNtEBdgJkNVUVNd+I/E6n9kI=";
    })
  ];

  sourceRoot = "${src.name}/${pname}";

  pythonRelaxDeps = [ "pyquil" ];

  postPatch = ''
    # Remove outdated test
    rm cirq_rigetti/service_test.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    cirq-core
    pyquil
    qcs-sdk-python
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_rigetti/_version_test.py"
  ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_rigetti" ];

  meta = {
    inherit (cirq-core.meta) changelog license maintainers;
    description = "Cirq package to simulate and connect to Rigetti quantum computers and Quil QVM";
    homepage = "https://github.com/quantumlib/Cirq/tree/main/cirq-rigetti";
  };
}
