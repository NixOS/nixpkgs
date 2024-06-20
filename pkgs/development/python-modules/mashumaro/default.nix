{
  lib,
  buildPythonPackage,
  ciso8601,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "3.13";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Fatal1ty";
    repo = "mashumaro";
    rev = "refs/tags/v${version}";
    hash = "sha256-ETK1rHKlByQkqibejiZmXF6c4eIiMazLa8XY2OH30q4=";
  };

  patches = [
    (fetchpatch2 {
      # Fix calling typing._evaluate on Python 3.12.4
      url = "https://github.com/Fatal1ty/mashumaro/commit/01b1d795e71ecb86c6c36a3b537473a9246df194.patch";
      hash = "sha256-YrRnXgv2UHD6BPezPadzOEVpaKZree6KO3K0JKZeDi0=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ typing-extensions ];

  passthru.optional-dependencies = {
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
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "mashumaro" ];

  meta = with lib; {
    description = "Serialization library on top of dataclasses";
    homepage = "https://github.com/Fatal1ty/mashumaro";
    changelog = "https://github.com/Fatal1ty/mashumaro/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ tjni ];
  };
}
