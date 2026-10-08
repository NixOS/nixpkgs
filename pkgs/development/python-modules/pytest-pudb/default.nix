{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest,
  pudb,
}:

buildPythonPackage {
  pname = "pytest-pudb";
  version = "0.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wronglink";
    repo = "pytest-pudb";
    # Repo missing tags for releases https://github.com/wronglink/pytest-pudb/issues/24
    rev = "a6b3d2f4d35e558d72bccff472ecde9c9d9c69e5";
    hash = "sha256-gI9p6sXCQaQjWBXaHJCFli6lBh8+pr+KPhz50fv1F7A=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ pudb ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_pudb" ];

  meta = {
    # https://github.com/wronglink/pytest-pudb/issues/28
    broken = lib.versionAtLeast pytest.version "8.4.0";
    description = "Pytest PuDB debugger integration";
    homepage = "https://github.com/wronglink/pytest-pudb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thornycrackers ];
  };
}
