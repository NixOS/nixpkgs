{ lib
, buildPythonPackage
, pythonOlder
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
      --replace "protobuf~=3.13.0" "protobuf" \
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
}
