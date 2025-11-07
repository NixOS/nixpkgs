{
  lib,
  buildPythonPackage,
  ciso8601,
  fetchFromGitHub,
  msgpack,
  orjson,
  pendulum,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  setuptools,
  tomli,
  tomli-w,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "mashumaro";
  version = "3.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Fatal1ty";
    repo = "mashumaro";
    tag = "v${version}";
    hash = "sha256-oQKSIDrIPlY1m63uP9Jxpgf7ruaZpt9uZF4hTso503U=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  optional-dependencies = {
    orjson = [ orjson ];
    msgpack = [ msgpack ];
    yaml = [ pyyaml ];
    toml = [ tomli-w ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];
  };

  nativeCheckInputs = [
    ciso8601
    pendulum
    pytest-mock
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "mashumaro" ];

  meta = {
    description = "Serialization library on top of dataclasses";
    homepage = "https://github.com/Fatal1ty/mashumaro";
    changelog = "https://github.com/Fatal1ty/mashumaro/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tjni ];
  };
}
