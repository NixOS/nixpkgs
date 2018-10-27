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
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c52f5ae13e35284feda8f6b67c0d6223c02c0292b1495969cf7a42f547b3fc18";
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
