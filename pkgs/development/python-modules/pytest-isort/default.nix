{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isort,
  poetry-core,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-isort";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stephrdev";
    repo = "pytest-isort";
    tag = version;
    hash = "sha256-fMt2tYc+Ngb57T/VJYxI2UN25qvIrgIsEoImVIitDK4=";
  };

  nativeBuildInputs = [ poetry-core ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ isort ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_isort" ];

  meta = {
    description = "Pytest plugin to perform isort checks (import ordering)";
    homepage = "https://github.com/moccu/pytest-isort/";
    changelog = "https://github.com/stephrdev/pytest-isort/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
