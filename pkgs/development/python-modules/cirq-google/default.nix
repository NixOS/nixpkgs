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
    substituteInPlace requirements.txt --replace "protobuf~=3.13.0" "protobuf"
  '';

  propagatedBuildInputs = [
    cirq-core
    google-api-core
    protobuf
  ];

  checkInputs = [ pytestCheckHook freezegun ];
}
