{
  buildPythonPackage,
  cirq-core,
  deprecation,
  fetchFromGitHub,
  h5py,
  lib,
  nbformat,
  networkx,
  numpy,
  pubchempy,
  pytestCheckHook,
  requests,
  setuptools,
  scipy,
  sympy,
}:

buildPythonPackage (finalAttrs: {
  pname = "openfermion";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "OpenFermion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rUTAvijAXPD3kTj44Ban4h9gYkr4TtiGOEk/Ft/PT0g=";
  };

  postPatch = ''
    # Required for pytest markers to work
    cp dev_tools/conf/pytest.ini pytest.ini
  '';

  build-system = [ setuptools ];

  dependencies = [
    cirq-core
    deprecation
    h5py
    networkx
    numpy
    pubchempy
    requests
    scipy
    sympy
  ];

  nativeCheckInputs = [
    nbformat
    pytestCheckHook
  ];

  disabledTests = [
    # Require Network
    "test_helium"
    "test_none"
    "test_water"
    "test_water_2d"
    # ValueError
    "test_dissolve"
    "test_transform"
    "test_bravyi_kitaev"
    "test_checksum_code"
    "test_interleaved_code"
    "test_jordan_wigner"
    "test_parity_code"
    "test_tranform_function"
    "test_weight_one_binary_addressing_code"
    "test_weight_one_segment_code"
    "test_weight_two_segment_code"
  ];

  pythonImportsCheck = [ "openfermion" ];

  meta = {
    changelog = "https://github.com/quantumlib/OpenFermion/releases/tag/v${finalAttrs.version}";
    description = "Python package for compiling and analyzing quantum algorithms to simulate electronic structures";
    homepage = "https://quantumai.google/openfermion";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ hythera ];
  };
})
