{ stdenv, buildPythonPackage, fetchPypi, oracle-instantclient }:

buildPythonPackage rec {
  pname = "cx_Oracle";
  version = "6.3.1";

  buildInputs = [
    oracle-instantclient
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0200j6jh80rpgzxmvgcxmkshaj4zadq32g2i97nlwiq3f7q374l7";
  };

  patches = [ ./0001-odpi-src-dpiOci.c-nixify-libclntsh.so-dlopen.patch ];

  postPatch = ''
    substituteInPlace odpi/src/dpiOci.c --replace @libclntsh@ "${oracle-instantclient}/lib/libclntsh.so";
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
