{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  isort,
  poetry-core,
  pytest,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytest-isort";
  version = "3.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stephrdev";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-1oCVIi0sXwac4AufScJJRsfvBwaBAwlMBRNqLcUXEh4=";
  };

  nativeBuildInputs = [ poetry-core ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ isort ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_isort" ];

  meta = with lib; {
    description = "Pytest plugin to perform isort checks (import ordering)";
    homepage = "https://github.com/moccu/pytest-isort/";
    changelog = "https://github.com/stephrdev/pytest-isort/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
