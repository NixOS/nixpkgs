{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "overrides";
  version = "7.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkorpela";
    repo = "overrides";
    tag = version;
    hash = "sha256-gQDw5/RpAFNYWFOuxIAArPkCOoBYWUnsDtv1FEFteHo=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # KeyError: 'assertRaises'
    "test_enforcing_when_incompatible"
  ];

  pythonImportsCheck = [ "overrides" ];

  meta = {
    description = "Decorator to automatically detect mismatch when overriding a method";
    homepage = "https://github.com/mkorpela/overrides";
    changelog = "https://github.com/mkorpela/overrides/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
