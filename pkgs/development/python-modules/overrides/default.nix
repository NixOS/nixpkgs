{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "overrides";
  version = "7.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkorpela";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7fbuBcb47BTVxAoKokZmGdIwHSyfyfSiCAZ4XZjWz60=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "overrides"
  ];

  meta = with lib; {
    description = "Decorator to automatically detect mismatch when overriding a method";
    homepage = "https://github.com/mkorpela/overrides";
    changelog = "https://github.com/mkorpela/overrides/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
