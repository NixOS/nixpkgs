{ stdenv, buildPythonPackage, fetchPypi, odpic }:

buildPythonPackage rec {
  pname = "cx_Oracle";
  version = "7.1.2";

  buildInputs = [ odpic ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d0e30d6ce62bedd41ae4885d43fff727314b67655ec8737b8af5cc0aad7f925";
  };

  preConfigure = ''
    export ODPIC_INC_DIR="${odpic}/include"
    export ODPIC_LIB_DIR="${odpic}/lib"
  '';

  # Check need an Oracle database to run
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python interface to Oracle";
    homepage = "https://oracle.github.io/python-cx_Oracle";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ y0no ];
  };
}
