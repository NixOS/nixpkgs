{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, protobuf
, googleapis-common-protos
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "proto-plus";
  version = "1.19.4";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "416dc38b090ca2093f6fac74977ac4a5599e496483a43c0076e6f6a4dd77ed9c";
  };

  propagatedBuildInputs = [ protobuf ];

  checkInputs = [ pytestCheckHook pytz googleapis-common-protos ];

  pythonImportsCheck = [ "proto" ];

  meta = with lib; {
    description = "Beautiful, idiomatic protocol buffers in Python";
    homepage = "https://github.com/googleapis/proto-plus-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ruuda SuperSandro2000 ];
  };
}
