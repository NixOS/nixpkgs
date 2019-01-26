{ stdenv, buildPythonPackage, fetchPypi, odpic }:

buildPythonPackage rec {
  pname = "cx_Oracle";
  version = "7.0.0";

  buildInputs = [ odpic ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "75ee5edccf385d8e8b1443058909fbf3477bb1db12ab7f367aafba8d993fc828";
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
