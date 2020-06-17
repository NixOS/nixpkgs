{ stdenv, buildPythonPackage, fetchPypi, numpy, cython }:

buildPythonPackage rec {
  pname = "pyemd";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc81c2116f8573e559dfbb8d73e03d9f73c22d0770559f406516984302e07e70";
  };

  propagatedBuildInputs = [ numpy ];
  buildInputs = [ cython ];

  meta = with stdenv.lib; {
    description = "A Python wrapper for Ofir Pele and Michael Werman's implementation of the Earth Mover's Distance";
    homepage = "https://github.com/wmayner/pyemd";
    license = licenses.mit;
    maintainers = with maintainers; [ rvl ];
  };
}
