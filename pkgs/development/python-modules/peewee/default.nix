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
  mysql-connector-python,
  withPostgres ? false,
  psycopg2,
  setuptools,
}:

buildPythonPackage rec {
  pname = "peewee";
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = "peewee";
    tag = version;
    hash = "sha256-1wUnxZCN1SKwH32iFU7JKaFtXukMuP3u9jg9dOjy0aM=";
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
  ++ lib.optionals withMysql [ mysql-connector-python ];

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
