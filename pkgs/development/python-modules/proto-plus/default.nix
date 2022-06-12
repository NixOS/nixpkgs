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
  version = "1.20.5";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gXlOsb4zPGeYYzOUjfcOu4zfU44Dn4z6kv0qnXF21AU=";
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
