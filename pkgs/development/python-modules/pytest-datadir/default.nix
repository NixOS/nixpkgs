{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-datadir";
  version = "1.4.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "gabrielcnr";
    repo = "pytest-datadir";
    rev = "refs/tags/${version}";
    sha256 = "sha256-HyJ0rU1nHqRv8SHFS8m3GZ5409+JZIkoDgIVjy4ol54=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;
  nativeBuildInputs = [ setuptools-scm ];
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "pytest_datadir" ];

  meta = with lib; {
    description = "Pytest plugin for manipulating test data directories and files";
    homepage = "https://github.com/gabrielcnr/pytest-datadir";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
