{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  protobuf,
  googleapis-common-protos,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "proto-plus";
  version = "1.23.0";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iQdRce8RmIs/oVf129i5zwnWX//ul+Kc5APNje+6GdI=";
  };

  propagatedBuildInputs = [ protobuf ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
    googleapis-common-protos
  ];

  pythonImportsCheck = [ "proto" ];

  meta = with lib; {
    description = "Beautiful, idiomatic protocol buffers in Python";
    homepage = "https://github.com/googleapis/proto-plus-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ruuda ];
  };
}
