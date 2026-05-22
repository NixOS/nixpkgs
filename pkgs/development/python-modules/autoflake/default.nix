{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pyflakes,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "autoflake";
  version = "2.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c9OyK62JA0h596SHHCecjRibPywLnZ4nS45bRowX+aA=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ pyflakes ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "autoflake" ];

  disabledTests = [
    # AssertionError: True is not false
    "test_is_literal_or_name"
  ];

  meta = {
    description = "Tool to remove unused imports and unused variables";
    mainProgram = "autoflake";
    homepage = "https://github.com/myint/autoflake";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yuriaisaka ];
  };
}
