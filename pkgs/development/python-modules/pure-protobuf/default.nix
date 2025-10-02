{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  typing-extensions,
  pytestCheckHook,
  pytest-benchmark,
  pytest-cov-stub,
  pydantic,
}:

buildPythonPackage rec {
  pname = "pure-protobuf";
  version = "3.1.5";

  format = "pyproject";
  # < 3.10 requires get-annotations which isn't packaged yet
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "eigenein";
    repo = "protobuf";
    tag = version;
    hash = "sha256-Gr5fKpagSUzH34IKHb+pBta4q71AqYa/KG9XW2AxZqk=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
    typing-extensions
  ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
    pytest-benchmark
    pytest-cov-stub
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "pure_protobuf" ];

  meta = with lib; {
    description = "Python implementation of Protocol Buffers with dataclass-based schemas";
    homepage = "https://github.com/eigenein/protobuf";
    changelog = "https://github.com/eigenein/protobuf/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
