{ lib
, stdenv
, fetchPypi
, buildPythonPackage
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
  version = "2023.1.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6wDNV0BJ1ZK2edz4v+erSjbJSjn9Gssaa0XWwNe+mmg=";
  };

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
