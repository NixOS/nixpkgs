{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  marshmallow,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  typeguard,
  typing-inspect,
}:

buildPythonPackage rec {
  pname = "marshmallow-dataclass";
  version = "8.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "marshmallow_dataclass";
    rev = "refs/tags/v${version}";
    hash = "sha256-O96Xv732euS0X+1ilhLVMoazpC4kUSJvyVYwdj10e2E=";
  };

  propagatedBuildInputs = [
    marshmallow
    typing-inspect
  ];

  nativeCheckInputs = [
    pytestCheckHook
    typeguard
  ];

  pytestFlagsArray = [
    # DeprecationWarning: The distutils package is deprecated and slated for removal in Python 3.12.
    "-W"
    "ignore::DeprecationWarning"
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
