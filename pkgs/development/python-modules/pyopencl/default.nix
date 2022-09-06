{ lib
, stdenv
, fetchpatch
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

  patches = [
    # Fix compilation error with pybind 2.10
    (fetchpatch {
      url = "https://github.com/inducer/pyopencl/commit/bf3cb670f30bc2c5dfec102b147b41146381d769.patch";
      hash = "sha256-TooY9o8BhH6xa1uwTPCPG6R2dMdA5MRTA6GS1u4LHak=";
    })
  ];

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
