{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, poetry-dynamic-versioning
, pydantic
, pytestCheckHook
, pytest-benchmark
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pure-protobuf";
  version = "3.0.1";  # Komikku not launching w/ 3.0.0, #280551

  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "eigenein";
    repo = "protobuf";
    rev = "refs/tags/${version}";
    hash = "sha256-sGKnta+agrpJkQB0twFkqRreD5WB2O/06g75N0ic4mc=";
  };

  postPatch = ''
    sed -i "/addopts =/d" pyproject.toml
  '';

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    typing-extensions
  ];

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
    pytest-benchmark
  ];

  pytestFlagsArray = [
    "--benchmark-disable"
  ];

  pythonImportsCheck = [
    "pure_protobuf"
  ];

  meta = with lib; {
    description = "Python implementation of Protocol Buffers with dataclass-based schemas";
    homepage = "https://github.com/eigenein/protobuf";
    changelog = "https://github.com/eigenein/protobuf/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
