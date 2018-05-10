{ stdenv, buildPythonPackage, fetchPypi, libmysql }:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "1.3.12";

  buildInputs = [
    libmysql
  ];

  # Tests need a MySQL database
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d9ec33de39f4d9c64ad7322ede0521d85829ce36a76f9dd3d6ab76a9c8648e5";
  };

  meta = with stdenv.lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl1;
    maintainers = with maintainers; [ y0no ];
  };
}
