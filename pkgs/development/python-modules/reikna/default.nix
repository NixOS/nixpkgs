{
  lib,
  fetchPypi,
  buildPythonPackage,
  sphinx,
  pytest-cov-stub,
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
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uzIoGCkIINgmO+r0vAzmihS14GWv5ygakMz3tKIG3zA=";
  };

  nativeCheckInputs = [
    sphinx
    pytest-cov-stub
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
