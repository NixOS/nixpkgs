{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "overrides";
  version = "7.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkorpela";
    repo = "overrides";
    rev = "refs/tags/${version}";
    hash = "sha256-gQDw5/RpAFNYWFOuxIAArPkCOoBYWUnsDtv1FEFteHo=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # KeyError: 'assertRaises'
    "test_enforcing_when_incompatible"
  ];

  pythonImportsCheck = [ "overrides" ];

  meta = with lib; {
    description = "Decorator to automatically detect mismatch when overriding a method";
    homepage = "https://github.com/mkorpela/overrides";
    changelog = "https://github.com/mkorpela/overrides/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
