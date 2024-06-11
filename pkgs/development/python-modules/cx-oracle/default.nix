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
    sha256 = "3b2d215af4441463c97ea469b9cc307460739f89fdfa8ea222ea3518f1a424d9";
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
