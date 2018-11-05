{ stdenv, buildPythonPackage, fetchPypi, isPyPy, unittest2 }:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9a7662ec724d0120012f6e29d6248ae3727d821bba522a0e6b356eff19126a49";
  };

  buildInputs = [ unittest2 ];

  # https://github.com/PyCQA/pyflakes/issues/386
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/pyflakes;
    description = "A simple program which checks Python source files for errors";
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
