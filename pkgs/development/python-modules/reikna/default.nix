{
  lib,
  fetchPypi,
  buildPythonPackage,
  sphinx,
  pytest-cov,
  pytest,
  mako,
  numpy,
  funcsigs,
  withCuda ? false,
  pycuda,
  withOpenCL ? true,
  pyopencl,
}:

buildPythonPackage rec {
  pname = "reikna";
  version = "0.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fpa1Pfo5EAafg7Pgha17G6k5G13fdErjclv0On/uYyI=";
  };

  nativeCheckInputs = [
    sphinx
    pytest-cov
    pytest
  ];

  propagatedBuildInputs =
    [
      mako
      numpy
      funcsigs
    ]
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
  };
}
