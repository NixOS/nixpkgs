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
  version = "0.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "52bbce24fa1fd7bb950d38ce9b60f497dd00ac6b26688d80ab9bce709f063e71";
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
