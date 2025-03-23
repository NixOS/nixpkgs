{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cryptography,
}:

buildPythonPackage rec {
  pname = "pymysql";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pymysql";
    inherit version;
    hash = "sha256-4SdhGq8rQXQDxgv03FcBJK60pX9fN7jpWuOZpC+QTNA=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ cryptography ];

  # Wants to connect to MySQL
  doCheck = false;

  meta = with lib; {
    description = "Pure Python MySQL Client";
    homepage = "https://github.com/PyMySQL/PyMySQL";
    license = licenses.mit;
    maintainers = [ maintainers.kalbasit ];
  };
}
