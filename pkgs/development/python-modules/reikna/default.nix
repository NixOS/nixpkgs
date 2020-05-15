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
  version = "0.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d01f4264c8379ef2962a93aacb002d491b92ef9b5b22b45f77e7821dfa87bef7";
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
    homepage = "https://github.com/fjarri/reikna";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.fridh ];

  };

}
