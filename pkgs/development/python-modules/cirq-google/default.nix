{ buildPythonPackage
, cirq-core
, google-api-core
, protobuf
, pytestCheckHook
, freezegun
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "cirq-google";
  format = "setuptools";
  inherit (cirq-core) version src meta;

  sourceRoot = "${src.name}/${pname}";

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "google-api-core[grpc] >= 1.14.0, < 2.0.0dev" "google-api-core[grpc] >= 1.14.0, < 3.0.0dev" \
      --replace "protobuf >= 3.15.0, < 4" "protobuf >= 3.15.0"
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
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
  ];

  disabledTests = [
    # unittest.mock.InvalidSpecError: Cannot autospec attr 'QuantumEngineServiceClient'
    "test_get_engine_sampler_explicit_project_id"
    "test_get_engine_sampler"
    # Calibration issue
    "test_xeb_to_calibration_layer"
  ];

}
