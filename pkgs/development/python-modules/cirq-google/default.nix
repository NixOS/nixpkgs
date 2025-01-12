{
  buildPythonPackage,
  cirq-core,
  freezegun,
  google-api-core,
  protobuf,
  pytestCheckHook,
  setuptools,
  protobuf4,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "cirq-google";
  pyproject = true;
  inherit (cirq-core) version src meta;

  sourceRoot = "${src.name}/${pname}";

  build-system = [ setuptools ];

  patches = [
    # https://github.com/quantumlib/Cirq/pull/6683 Support for protobuf5
    (fetchpatch {
      url = "https://github.com/quantumlib/Cirq/commit/bae02e4d83aafa29f50aa52073d86eb913ccb2d3.patch";
      hash = "sha256-MqHhKa38BTM6viQtWik0TQjN0OPdrwzCZkkqZsiyF5w=";
      includes = [ "cirq_google/serialization/arg_func_langs_test.py" ];
      stripLen = 1;
    })
  ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    cirq-core
    google-api-core
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

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
