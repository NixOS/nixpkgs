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
  version = "1.27.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "proto-plus-python";
    tag = "v${version}";
    hash = "sha256-Ya7BY0ZyAAEzomJVExd1cF5r11gTHXeHcjPRqkBjeuQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ protobuf ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
    googleapis-common-protos
  ];

  pytestFlags = [
    # pkg_resources is deprecated as an API. See https://setuptools.pypa.io/en/latest/pkg_resources.html
    "-Wignore::DeprecationWarning"
    # float_precision option is deprecated for json_format error with latest protobuf
    "-Wignore:float_precision:UserWarning"
  ];

  pythonImportsCheck = [ "proto" ];

  meta = {
    description = "Beautiful, idiomatic protocol buffers in Python";
    homepage = "https://github.com/googleapis/proto-plus-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ruuda ];
  };
}
