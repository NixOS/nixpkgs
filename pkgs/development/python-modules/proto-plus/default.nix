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
  version = "1.25.0";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    pname = "proto_plus";
    inherit version;
    hash = "sha256-+7F/V/e9BaaLdwfnReJlKLCzw043jbke75ORLFSYLZE=";
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
