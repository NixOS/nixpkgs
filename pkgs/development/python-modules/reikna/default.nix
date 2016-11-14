{ stdenv
, fetchurl
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
  name = "${pname}-${version}";
  version = "0.6.7";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "810b349eb9339aa0d13bca99a3d8a380972708474b8c0990d188ec6074358d62";
  };

  buildInputs = [ sphinx pytestcov pytest ];

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
    homepage = http://github.com/fjarri/reikna;
    license = stdenv.lib.licenses.mit;
    maintainer = stdenv.lib.maintainers.fridh;

  };

}