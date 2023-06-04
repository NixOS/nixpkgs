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
, opencl-headers
, platformdirs
, pybind11
, pytest
, pytestCheckHook
, pytools
, setuptools
, six
}:

let
  os-specific-buildInputs =
    if stdenv.isDarwin then [ mesa_drivers.dev ] else [ ocl-icd ];
in buildPythonPackage rec {
  pname = "pyopencl";
  version = "2023.1";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2d5gcnKRmlB6nCTD3+7q/nLAX3zWyeN7IRno7jxTqJE=";
  };

  nativeBuildInputs = [ setuptools ];

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
