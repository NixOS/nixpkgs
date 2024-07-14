{
  lib,
  buildPythonPackage,
  fetchPypi,
  odpic,
}:

buildPythonPackage rec {
  pname = "cx-oracle";
  version = "8.3.0";

  buildInputs = [ odpic ];

  src = fetchPypi {
    pname = "cx_Oracle";
    inherit version;
    hash = "sha256-Oy0hWvREFGPJfqRpucwwdGBzn4n9+o6iIuo1GPGkJNk=";
  };

  preConfigure = ''
    export ODPIC_INC_DIR="${odpic}/include"
    export ODPIC_LIB_DIR="${odpic}/lib"
  '';

  # Check need an Oracle database to run
  doCheck = false;

  meta = with lib; {
    description = "Python interface to Oracle";
    homepage = "https://oracle.github.io/python-cx_Oracle";
    license = licenses.bsd3;
    maintainers = with maintainers; [ y0no ];
  };
}
