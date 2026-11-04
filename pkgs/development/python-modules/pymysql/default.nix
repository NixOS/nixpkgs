{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cryptography,
}:

buildPythonPackage rec {
  pname = "pymysql";
  version = "1.2.3";
  pyproject = true;

  src = fetchPypi {
    pname = "pymysql";
    inherit version;
    hash = "sha256-1bKIUpeC5TauFxhm3zyp3E9sv7PMLxjm+Df7uQ28Jis=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ cryptography ];

  # Wants to connect to MySQL
  doCheck = false;

  meta = {
    description = "Pure Python MySQL Client";
    homepage = "https://github.com/PyMySQL/PyMySQL";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kalbasit ];
  };
}
