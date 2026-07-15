{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cryptography,
}:

buildPythonPackage rec {
  pname = "pymysql";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    pname = "pymysql";
    inherit version;
    hash = "sha256-SWHT4WVhSuZQFONhgRpyTiBErT6jc53pkDrnwh9TnwM=";
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
