{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyPdf";
  version = "1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3aede4c3c9c6ad07c98f059f90db0b09ed383f7c791c46100f649e1cabda0e3b";
  };

  # Not supported. Package is no longer maintained.
  disabled = isPy3k;

  meta = with stdenv.lib; {
    description = "Pure-Python PDF toolkit";
    homepage = "http://pybrary.net/pyPdf/";
    license = licenses.bsd3;
  };

}
