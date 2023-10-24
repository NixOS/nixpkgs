{ lib
, buildPythonPackage
, fetchPypi
, libmysqlclient
, pkg-config
}:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "2.2.0";

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
    hash = "sha256-BDaERfnEh9irt6h449I+kj5gcsBKbDIPng3IqC77oU4=";
  };

  meta = with lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ y0no ];
  };
}
