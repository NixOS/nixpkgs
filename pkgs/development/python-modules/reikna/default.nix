{ stdenv
, fetchPypi
, buildPythonPackage
, sphinx
, pytestcov
, pytest
, Mako
, numpy
, funcsigs
, withCuda ? false, pycuda
, withOpenCL ? true, pyopencl
}:

buildPythonPackage rec {
  pname = "reikna";
  version = "0.6.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "34d92786237bef9ab5d37d78f01c155d0dcd1fc24df7782af9498a9f1786890c";
  };

  checkInputs = [ sphinx pytestcov pytest ];

  propagatedBuildInputs = [ Mako numpy funcsigs ]
    ++ stdenv.lib.optional withCuda pycuda
    ++ stdenv.lib.optional withOpenCL pyopencl;

  checkPhase = ''
    py.test
  '';

  # Requires device
  doCheck = false;

  meta = {
    description = "GPGPU algorithms for PyCUDA and PyOpenCL";
    homepage = https://github.com/fjarri/reikna;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.fridh ];

  };

}
