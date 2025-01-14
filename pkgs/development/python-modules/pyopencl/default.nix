{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, fetchpatch
, appdirs
, cffi
, decorator
, mako
, mesa_drivers
, numpy
, ocl-icd
, oldest-supported-numpy
, opencl-headers
, platformdirs
, pybind11
, pytest
, pytestCheckHook
, pytools
, setuptools
, six
, wheel
}:

let
  os-specific-buildInputs =
    if stdenv.isDarwin then [ mesa_drivers.dev ] else [ ocl-icd ];
in buildPythonPackage rec {
  pname = "pyopencl";
  version = "2023.1.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IgF078qQDp1d5a7yqht3pvJVBQHekrA1qRATrq5NTF4=";
  };

  patches = [
    (fetchpatch {
      name = "fix-conditions-for-CL_UNORM_INT24-availability.patch";
      url = "https://github.com/inducer/pyopencl/pull/706.patch";
      hash = "sha256-31aiqYlhbEw3F2k/x3W2rbOX0A90cHwIlfXMivFucMA=";
    })
  ];

  nativeBuildInputs = [
    oldest-supported-numpy
    setuptools
    wheel
  ];

  buildInputs = [ opencl-headers pybind11 ] ++ os-specific-buildInputs;

  propagatedBuildInputs = [
    appdirs
    cffi
    decorator
    mako
    numpy
    platformdirs
    pytools
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  # gcc: error: pygpu_language_opencl.cpp: No such file or directory
  doCheck = false;

  pythonImportsCheck = [ "pyopencl" ];

  meta = with lib; {
    description = "Python wrapper for OpenCL";
    homepage = "https://github.com/pyopencl/pyopencl";
    license = licenses.mit;
    maintainers = [ maintainers.fridh ];
  };
}
