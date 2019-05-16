{ stdenv, buildPythonPackage, fetchPypi, isPyPy, unittest2 }:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d976835886f8c5b31d47970ed689944a0262b5f3afa00a5a7b4dc81e5449f8a2";
  };

  checkInputs = [ unittest2 ];

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/pyflakes;
    description = "A simple program which checks Python source files for errors";
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
