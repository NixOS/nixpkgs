{
  lib,
  buildPythonPackage,
  fetchPypi,
  libmysqlclient,
  pkg-config,
}:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "2.2.4";
  format = "setuptools";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libmysqlclient ];

  # Tests need a MySQL database
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M7yfs0ZOfXwQser3M2xf+PKj07iLq0MhFq0kkL6zv0E=";
  };

  meta = with lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ y0no ];
  };
}
