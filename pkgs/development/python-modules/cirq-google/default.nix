{ buildPythonPackage
, cirq-core
, google-api-core
, protobuf
# test inputs
, pytestCheckHook
, freezegun
}:

buildPythonPackage rec {
  pname = "cirq-google";
  inherit (cirq-core) version src meta;

  sourceRoot = "source/${pname}";

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "google-api-core[grpc] >= 1.14.0, < 2.0.0dev" "google-api-core[grpc] >= 1.14.0, < 3.0.0dev"
  '';

  propagatedBuildInputs = [
    cirq-core
    google-api-core
    protobuf
  ];

  checkInputs = [
    freezegun
    pytestCheckHook
  ];

  disabledTests = [
    # unittest.mock.InvalidSpecError: Cannot autospec attr 'QuantumEngineServiceClient'
    "test_get_engine_sampler_explicit_project_id"
    "test_get_engine_sampler"
  ];
}
