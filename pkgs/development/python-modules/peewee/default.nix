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
<<<<<<< HEAD
  version = "3.18.3";
=======
  version = "3.18.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = "peewee";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-gMoU6YQMlEfL6onRAA/8v/08Je2jeLoZ3zw+2n1fmw4=";
=======
    hash = "sha256-BIOY3vAHzSonxXYFmfFbVxbbUWnUVtcBRsTVMRo7peE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Python ORM with support for various database implementation";
    homepage = "http://peewee-orm.com";
    changelog = "https://github.com/coleifer/peewee/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Python ORM with support for various database implementation";
    homepage = "http://peewee-orm.com";
    changelog = "https://github.com/coleifer/peewee/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "pwiz.py";
  };
}
