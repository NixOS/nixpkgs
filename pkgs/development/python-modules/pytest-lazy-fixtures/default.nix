{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-lazy-fixtures";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dev-petrov";
    repo = "pytest-lazy-fixtures";
    rev = version;
    hash = "sha256-BOKUg5HPBQfteKOEsdZ30h/hWbVZPuHMhtGXF3KfMXg=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_lazy_fixtures" ];

  meta = with lib; {
    description = "Allows you to use fixtures in @pytest.mark.parametrize";
    homepage = "https://github.com/dev-petrov/pytest-lazy-fixtures";
    license = licenses.mit;
    maintainers = [ ];
  };
}
