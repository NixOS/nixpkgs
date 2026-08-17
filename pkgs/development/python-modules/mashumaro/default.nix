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
  pyyaml,
  setuptools,
  tomli-w,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "mashumaro";
  version = "3.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Fatal1ty";
    repo = "mashumaro";
    tag = "v${version}";
    hash = "sha256-SWmZA/yoiElQ299+BkjwTdcPukKfgw/UgUwiesFRkqo=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  optional-dependencies = {
    orjson = [ orjson ];
    msgpack = [ msgpack ];
    yaml = [ pyyaml ];
    toml = [ tomli-w ];
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
  };
}
