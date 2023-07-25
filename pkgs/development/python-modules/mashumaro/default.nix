{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, typing-extensions
, orjson
, msgpack
, pyyaml
, tomli-w
, tomli
, pytestCheckHook
, ciso8601
, pendulum
, pytest-mock
}:

buildPythonPackage rec {
  pname = "mashumaro";
  version = "3.8.1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Fatal1ty";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-WDKohmcdVlQR/6AMSISN0y6UQx4tmOf1fANCPLRYiqI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

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

  pythonImportsCheck = [
    "mashumaro"
  ];

  meta = with lib; {
    description = "Fast and well tested serialization library on top of dataclasses";
    homepage = "https://github.com/Fatal1ty/mashumaro";
    changelog = "https://github.com/Fatal1ty/mashumaro/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ tjni ];
  };
}
