{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  protobuf,
  googleapis-common-protos,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "proto-plus";
  version = "1.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "proto-plus-python";
    tag = "v${version}";
    hash = "sha256-rRA5t3QPVSeAqy60icrgvYKbvrClv22I3IYxHoMftQ0=";
  };

  build-system = [ setuptools ];

  dependencies = [ protobuf ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
    googleapis-common-protos
  ];

  pythonImportsCheck = [ "proto" ];

  meta = {
    description = "Beautiful, idiomatic protocol buffers in Python";
    homepage = "https://github.com/googleapis/proto-plus-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ruuda ];
  };
}
