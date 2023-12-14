{ lib
, buildPythonPackage
, ciso8601
, fetchFromGitHub
, msgpack
, orjson
, pendulum
, pytest-mock
, pytestCheckHook
, pythonOlder
, pyyaml
, setuptools
, tomli
, tomli-w
, typing-extensions
}:

buildPythonPackage rec {
  pname = "mashumaro";
  version = "3.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Fatal1ty";
    repo = "mashumaro";
    rev = "refs/tags/v${version}";
    hash = "sha256-7gRbTNNK8elWsL0ub7c/EeswIk4xxJOxKVk8HmvWMZA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  passthru.optional-dependencies = {
    orjson = [
      orjson
    ];
    msgpack = [
      msgpack
    ];
    yaml = [
      pyyaml
    ];
    toml = [
      tomli-w
    ] ++ lib.optionals (pythonOlder "3.11") [
      tomli
    ];
  };

  nativeCheckInputs = [
    ciso8601
    pendulum
    pytest-mock
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "mashumaro"
  ];

  meta = with lib; {
    description = "Serialization library on top of dataclasses";
    homepage = "https://github.com/Fatal1ty/mashumaro";
    changelog = "https://github.com/Fatal1ty/mashumaro/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ tjni ];
  };
}
