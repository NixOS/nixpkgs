{ lib
, buildPythonPackage
, fetchPypi
, libmysqlclient
, pkg-config
}:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "2.2.3";
  format = "setuptools";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libmysqlclient
  ];

  # Tests need a MySQL database
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7lFlbjb8WpKSC4B+6Lnjc+Ow4mfInNyV1zsdvkaGNjE=";
  };

  meta = with lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ y0no ];
  };
}
