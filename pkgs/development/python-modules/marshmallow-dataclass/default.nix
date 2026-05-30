{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  marshmallow,
  pytestCheckHook,
  setuptools,
  typeguard,
  typing-inspect,
}:

buildPythonPackage (finalAttrs: {
  pname = "marshmallow-dataclass";
  version = "8.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "marshmallow_dataclass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0OXP78oyNe/UcI05NHskPyXAuX3dwAW4Uz4dI4b8KV0=";
  };

  patches = [
    # Fix test_set_only_work_in_hashable_types on Python 3.14, https://github.com/lovasoa/marshmallow_dataclass/pull/286
    (fetchpatch {
      name = "fix-test.patch";
      url = "https://github.com/lovasoa/marshmallow_dataclass/commit/9a2ea19924a3cd5fadeb41663bfca64b9c0f75e4.patch";
      hash = "sha256-T2UbZdCj4+HRglMp8w3kU20sUcN6WoSyKiLNr1kSius=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    marshmallow
    typing-inspect
  ];

  nativeCheckInputs = [
    pytestCheckHook
    typeguard
  ];

  pytestFlags = [
    # DeprecationWarning: The distutils package is deprecated and slated for removal in Python 3.12.
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # TypeError: UserId is not a dataclass and cannot be turned into one.
    "test_newtype"
  ];

  pythonImportsCheck = [ "marshmallow_dataclass" ];

  meta = {
    description = "Automatic generation of marshmallow schemas from dataclasses";
    homepage = "https://github.com/lovasoa/marshmallow_dataclass";
    changelog = "https://github.com/lovasoa/marshmallow_dataclass/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
