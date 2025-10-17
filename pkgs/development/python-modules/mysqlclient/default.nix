{
  lib,
  buildPythonPackage,
  fetchPypi,
  libmysqlclient,
  pkg-config,
}:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "2.2.7";
  format = "setuptools";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libmysqlclient ];

  # Tests need a MySQL database
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JK4itZQW1fzOfpnJ03VINQtFZbqsgvleFJysbOQWOEU=";
  };

  meta = with lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl2Only;
  };
}
