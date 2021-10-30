{ lib, buildPythonPackage, fetchPypi, odpic }:

buildPythonPackage rec {
  pname = "cx_Oracle";
  version = "8.2.1";

  buildInputs = [ odpic ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "12e7e913a7a10fd8caafb9855e6703a601b7dd5cc596fcd489d0ac9529608b6c";
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
