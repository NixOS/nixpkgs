{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libmysqlclient,
  pkg-config,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mysqlclient";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyMySQL";
    repo = "mysqlclient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-15FN6XY8dcw51YNBALD6JQD/nejLuMyDZx9uHK6NU1k=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libmysqlclient ];

  # Tests need a MySQL database
  doCheck = false;

  pythonImportsCheck = [
    "MySQLdb"
    "MySQLdb._mysql"
    "MySQLdb._exceptions"
    "MySQLdb.connections"
    "MySQLdb.constants"
    "MySQLdb.converters"
    "MySQLdb.cursors"
    "MySQLdb.times"
  ];

  meta = {
    changelog = "https://github.com/PyMySQL/mysqlclient/releases/tag/${finalAttrs.src.tag}";
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = lib.licenses.gpl2Only;
  };
})
