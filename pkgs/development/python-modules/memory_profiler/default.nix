{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "memory_profiler";
  version = "0.41";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dce6e931c281662a500b142595517d095267216472c2926e5ec8edab89898d10";
  };

  # Tests don't import profile
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A module for monitoring memory usage of a python program";
    homepage = https://pypi.python.org/pypi/memory_profiler;
    license = licenses.bsd3;
  };

}
