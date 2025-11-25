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
  version = "1.26.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "proto-plus-python";
    tag = "v${version}";
    hash = "sha256-7FonHHXpgJC0vg9Y26bqz0g1NmLWwaZWyFZ0kv7PjY8=";
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

  meta = with lib; {
    description = "Beautiful, idiomatic protocol buffers in Python";
    homepage = "https://github.com/googleapis/proto-plus-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ruuda ];
  };
}
