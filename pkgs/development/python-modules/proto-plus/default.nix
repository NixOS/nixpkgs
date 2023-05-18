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
  version = "1.22.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DozaPVpjTZiVt1xXPJNSwWSGy3XesOB4tf2jTbQkMWU=";
  };

  propagatedBuildInputs = [ protobuf ];

  nativeCheckInputs = [ pytestCheckHook pytz googleapis-common-protos ];

  pythonImportsCheck = [ "proto" ];

  meta = with lib; {
    description = "Beautiful, idiomatic protocol buffers in Python";
    homepage = "https://github.com/googleapis/proto-plus-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ruuda SuperSandro2000 ];
  };
}
