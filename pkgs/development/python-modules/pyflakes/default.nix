{ stdenv, buildPythonPackage, fetchPypi, isPyPy, unittest2 }:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e8c00e30c464c99e0b501dc160b13a14af7f27d4dffb529c556e30a159e231d";
  };

  checkInputs = [ unittest2 ];

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/pyflakes;
    description = "A simple program which checks Python source files for errors";
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
