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
  version = "1.20.6";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RJtFN+g/R3a9aQUcTXdtuP/j+dBkHx6HsGwRbrlMkOk=";
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
