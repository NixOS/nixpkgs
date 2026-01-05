{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-lazy-fixtures";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dev-petrov";
    repo = "pytest-lazy-fixtures";
    tag = version;
    hash = "sha256-h2Zm8Vbw3L9WeXaeFE/fJqiOgI3r+XnJUnnELDkmyaU=";
  };

  postPatch = ''
    # Prevent double registration here and in the pyproject.toml entrypoint
    # ValueError: Plugin already registered under a different name:
    substituteInPlace tests/conftest.py \
      --replace-fail '"pytest_lazy_fixtures.plugin",' ""
  '';

  build-system = [ hatchling ];

  dependencies = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # missing pytest-deadfixtures
    "tests/test_deadfixtures_support.py"
  ];

  pythonImportsCheck = [ "pytest_lazy_fixtures" ];

  meta = with lib; {
    description = "Allows you to use fixtures in @pytest.mark.parametrize";
    homepage = "https://github.com/dev-petrov/pytest-lazy-fixtures";
    license = licenses.mit;
    maintainers = [ ];
  };
}
