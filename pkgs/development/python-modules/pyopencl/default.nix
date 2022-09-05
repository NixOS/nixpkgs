{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, appdirs
, cffi
, decorator
, Mako
, mesa_drivers
, numpy
, ocl-icd
, opencl-headers
, platformdirs
, pybind11
, pytest
, pytools
, six
}:

let
  os-specific-buildInputs =
    if stdenv.isDarwin then [ mesa_drivers.dev ] else [ ocl-icd ];
in buildPythonPackage rec {
  pname = "pyopencl";
  version = "2022.1.6";

  checkInputs = [ pytest ];
  buildInputs = [ opencl-headers pybind11 ] ++ os-specific-buildInputs;

  propagatedBuildInputs = [
    appdirs
    cffi
    decorator
    Mako
    numpy
    platformdirs
    pytools
    six
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+Ih9VOZUWY84VEclQLLrIorFa1aiSRuVvfrI8VvhyUM=";
  };

  # py.test is not needed during runtime, so remove it from `install_requires`
  postPatch = ''
    substituteInPlace setup.py --replace "pytest>=2" ""
  '';

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  # gcc: error: pygpu_language_opencl.cpp: No such file or directory
  doCheck = false;

  meta = with lib; {
    description = "Python wrapper for OpenCL";
    homepage = "https://github.com/pyopencl/pyopencl";
    license = licenses.mit;
    maintainers = [ maintainers.fridh ];
  };
}
