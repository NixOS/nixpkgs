{ stdenv
, buildPythonPackage
, fetchPypi
, psutil
, python
}:

buildPythonPackage rec {
  pname = "memory_profiler";
  version = "0.54.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d64342a23f32e105f4929b408a8b89d9222c3ce8afbbb3359817555811448d1a";
  };

  propagatedBuildInputs = [ psutil ];

  checkPhase = ''
    make test PYTHON=${python.interpreter}
  '';

  # Tests don't import profile
  # doCheck = false;

  meta = with stdenv.lib; {
    description = "A module for monitoring memory usage of a python program";
    homepage = https://pypi.python.org/pypi/memory_profiler;
    license = licenses.bsd3;
  };

}
