{ lib
, buildPythonPackage
, fetchPypi
, libmysqlclient
, pkg-config
}:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "2.2.1";
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
    hash = "sha256-LHrRW4cpOxL9RLR8RoeeyV7GR/RWfoZszXC4M3WE6bI=";
  };

  meta = with lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ y0no ];
  };
}
