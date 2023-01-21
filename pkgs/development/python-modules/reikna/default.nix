{ lib
, fetchPypi
, buildPythonPackage
, sphinx
, pytest-cov
, pytest
, Mako
, numpy
, funcsigs
, withCuda ? false, pycuda
, withOpenCL ? true, pyopencl
}:

buildPythonPackage rec {
  pname = "reikna";
  version = "0.7.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "722fefbd253d0bbcbf5250b7b9c4aca5722cde4ca38bfbf863a551a5fc26edfa";
  };

  nativeCheckInputs = [ sphinx pytest-cov pytest ];

  propagatedBuildInputs = [ Mako numpy funcsigs ]
    ++ lib.optional withCuda pycuda
    ++ lib.optional withOpenCL pyopencl;

  checkPhase = ''
    py.test
  '';

  # Requires device
  doCheck = false;

  meta = with lib; {
    description = "GPGPU algorithms for PyCUDA and PyOpenCL";
    homepage = "https://github.com/fjarri/reikna";
    license = licenses.mit;
    maintainers = [ maintainers.fridh ];

  };

}
