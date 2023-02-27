{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dissect-sql";
  version = "3.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.sql";
    rev = "refs/tags/${version}";
    hash = "sha256-sIXFEckHFr9H4oGFw8uuC+c54PR8ZbQxJKb5x5EixxQ=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.sql"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parsers for the SQLite database file format";
    homepage = "https://github.com/fox-it/dissect.sql";
    changelog = "https://github.com/fox-it/dissect.sql/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
