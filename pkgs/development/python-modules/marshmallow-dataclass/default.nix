{ lib
, buildPythonPackage
, fetchFromGitHub
, marshmallow
, marshmallow-enum
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, typeguard
, typing-inspect
}:

buildPythonPackage rec {
  pname = "marshmallow-dataclass";
  version = "8.5.9";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "marshmallow_dataclass";
    rev = "v${version}";
    sha256 = "sha256-gA5GxE2as/P5yT3ymvXmLQfG2GyZE7Fj+zBaT88O4vY=";
  };

  propagatedBuildInputs = [
    marshmallow
    typing-inspect
  ];

  checkInputs = [
    marshmallow-enum
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

  pythonImportsCheck = [
    "marshmallow_dataclass"
  ];

  meta = with lib; {
    description = "Automatic generation of marshmallow schemas from dataclasses";
    homepage = "https://github.com/lovasoa/marshmallow_dataclass";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
