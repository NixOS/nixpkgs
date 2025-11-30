{
  buildPythonPackage,
  setuptools,
  cirq-core,
  google-api-core,
  protobuf,
  freezegun,
  pytestCheckHook,
  typedunits,
}:

buildPythonPackage rec {
  pname = "cirq-google";
  pyproject = true;
  inherit (cirq-core) version src meta;

  sourceRoot = "${src.name}/${pname}";

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    cirq-core
    google-api-core
    protobuf
    typedunits
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_google/_version_test.py"
    # Trace/BPT trap: 5
    "cirq_google/engine/calibration_test.py"
    # Very time-consuming
    "cirq_google/engine/*_test.py"
  ];

  disabledTests = [
    # unittest.mock.InvalidSpecError: Cannot autospec attr 'QuantumEngineServiceClient'
    "test_get_engine_sampler_explicit_project_id"
    "test_get_engine_sampler"
    # Calibration issue
    "test_xeb_to_calibration_layer"
  ];
}
