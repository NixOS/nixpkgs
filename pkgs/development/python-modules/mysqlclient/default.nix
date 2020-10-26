{ stdenv, buildPythonPackage, isPy27, fetchPypi, libmysqlclient }:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "2.0.1";
  disabled = isPy27;

  nativeBuildInputs = [
    libmysqlclient
  ];

  buildInputs = [
    libmysqlclient
  ];

  # Tests need a MySQL database
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb2f75aea14722390d2d8ddf384ad99da708c707a96656210a7be8af20a2c5e5";
  };

  meta = with stdenv.lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl1;
    maintainers = with maintainers; [ y0no ];
  };
}
