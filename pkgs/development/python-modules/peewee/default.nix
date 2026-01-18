{
  lib,
  apsw,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  flask,
  python,
  sqlite,
  withMysql ? false,
  mysql-connector,
  withPostgres ? false,
  psycopg2,
  setuptools,
}:

buildPythonPackage rec {
  pname = "peewee";
  version = "3.18.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = "peewee";
    tag = version;
    hash = "sha256-gMoU6YQMlEfL6onRAA/8v/08Je2jeLoZ3zw+2n1fmw4=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    sqlite
    cython
  ];

  propagatedBuildInputs = [
    apsw
  ]
  ++ lib.optionals withPostgres [ psycopg2 ]
  ++ lib.optionals withMysql [ mysql-connector ];

  nativeCheckInputs = [ flask ];

  doCheck = withPostgres;

  checkPhase = ''
    rm -r playhouse # avoid using the folder in the cwd
    ${python.interpreter} runtests.py
  '';

  pythonImportsCheck = [ "peewee" ];

  meta = {
    description = "Python ORM with support for various database implementation";
    homepage = "http://peewee-orm.com";
    changelog = "https://github.com/coleifer/peewee/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "pwiz.py";
  };
}
