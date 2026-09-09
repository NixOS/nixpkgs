{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  marshmallow,
  poetry-core,
  poetry-dynamic-versioning,
  pytestCheckHook,
  typing-inspect,
}:

buildPythonPackage rec {
  pname = "dataclasses-json";
  version = "0.6.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lidatong";
    repo = "dataclasses-json";
    tag = "v${version}";
    hash = "sha256-AH/T6pa/CHtQNox67fqqs/BBnUcmThvbnSHug2p33qM=";
  };

  patches = [
    ./marshmallow-4.0-compat.patch
    # https://github.com/lidatong/dataclasses-json/pull/565
    ./python-3.14-compat.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'documentation =' 'Documentation =' \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  pythonRelaxDeps = [ "marshmallow" ];

  dependencies = [
    typing-inspect
    marshmallow
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # fails to deserialize None with marshmallow 4.0
    "test_deserialize"
  ];

  disabledTestPaths = [
    # fails with the following error and avoid dependency on mypy
    # mypy_main(None, text_io, text_io, [__file__], clean_exit=True)
    # TypeError: main() takes at most 4 arguments (5 given)
    "tests/test_annotations.py"
  ];

  pythonImportsCheck = [ "dataclasses_json" ];

  meta = {
    description = "Simple API for encoding and decoding dataclasses to and from JSON";
    homepage = "https://github.com/lidatong/dataclasses-json";
    changelog = "https://github.com/lidatong/dataclasses-json/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ albakham ];
  };
}
