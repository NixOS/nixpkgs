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
<<<<<<< HEAD
, oldest-supported-numpy
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, opencl-headers
, platformdirs
, pybind11
, pytest
<<<<<<< HEAD
, pytestCheckHook
, pytools
, setuptools
, six
, wheel
=======
, pytools
, six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  os-specific-buildInputs =
    if stdenv.isDarwin then [ mesa_drivers.dev ] else [ ocl-icd ];
in buildPythonPackage rec {
  pname = "pyopencl";
<<<<<<< HEAD
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

=======
  version = "2022.3.1";

  nativeCheckInputs = [ pytest ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  nativeCheckInputs = [ pytestCheckHook ];
=======
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Sj2w/mG1zclSZ1Jt7r1xp+HXlWlNSw/idh8GMLzKNiE=";
  };

  # py.test is not needed during runtime, so remove it from `install_requires`
  postPatch = ''
    substituteInPlace setup.py --replace "pytest>=2" ""
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  # gcc: error: pygpu_language_opencl.cpp: No such file or directory
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [ "pyopencl" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Python wrapper for OpenCL";
    homepage = "https://github.com/pyopencl/pyopencl";
    license = licenses.mit;
    maintainers = [ maintainers.fridh ];
  };
}
