{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  marshmallow,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  typeguard,
  typing-extensions,
  typing-inspect,
}:

buildPythonPackage rec {
  pname = "marshmallow-dataclass";
  version = "8.7.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "marshmallow_dataclass";
    tag = "v${version}";
    hash = "sha256-0OXP78oyNe/UcI05NHskPyXAuX3dwAW4Uz4dI4b8KV0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    marshmallow
    typing-inspect
  ]
  ++ lib.optionals (pythonOlder "3.10") [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    typeguard
  ];

  pytestFlags = [
    # DeprecationWarning: The distutils package is deprecated and slated for removal in Python 3.12.
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # TypeError: UserId is not a dataclass and cannot be turned into one.
    "test_newtype"
  ];

  pythonImportsCheck = [ "marshmallow_dataclass" ];

  meta = with lib; {
    description = "Automatic generation of marshmallow schemas from dataclasses";
    homepage = "https://github.com/lovasoa/marshmallow_dataclass";
    changelog = "https://github.com/lovasoa/marshmallow_dataclass/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
