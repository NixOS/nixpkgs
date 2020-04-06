{ stdenv, buildPythonPackage, fetchPypi, libmysqlclient }:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "1.4.6";

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
    sha256 = "f3fdaa9a38752a3b214a6fe79d7cae3653731a53e577821f9187e67cbecb2e16";
  };

  meta = with stdenv.lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl1;
    maintainers = with maintainers; [ y0no ];
  };
}
