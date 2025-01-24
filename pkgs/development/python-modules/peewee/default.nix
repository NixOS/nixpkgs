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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "peewee";
  version = "3.17.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = "peewee";
    rev = "refs/tags/${version}";
    hash = "sha256-j10c3mnrHISk04l65ieUB11jt3a3iiQsroTt/L0tKaw=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    sqlite
    cython
  ];

  propagatedBuildInputs = [
    apsw
  ] ++ lib.optionals withPostgres [ psycopg2 ] ++ lib.optionals withMysql [ mysql-connector ];

  nativeCheckInputs = [ flask ];

  doCheck = withPostgres;

  checkPhase = ''
    rm -r playhouse # avoid using the folder in the cwd
    ${python.interpreter} runtests.py
  '';

  pythonImportsCheck = [ "peewee" ];

  meta = with lib; {
    description = "Python ORM with support for various database implementation";
    homepage = "http://peewee-orm.com";
    changelog = "https://github.com/coleifer/peewee/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "pwiz.py";
  };
}
