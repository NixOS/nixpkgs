{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
<<<<<<< HEAD
, cmake
, cython
, ninja
, oldest-supported-numpy
, scikit-build
, setuptools
, wheel
=======
, setuptools
, scikit-build
, cython
, cmake
, ninja
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

# propagates
, msgpack
, ndindex
, numpy
, py-cpuinfo
, rich

# tests
, psutil
, pytestCheckHook
, torch
}:

buildPythonPackage rec {
  pname = "blosc2";
  version = "2.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "python-blosc2";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-nbPMLkTye0/Q05ubE35LssN677sUIQErPTxjAtSuGgI=";
  };

  postPatch = ''
    substituteInPlace requirements-runtime.txt \
      --replace "pytest" ""
  '';

  nativeBuildInputs = [
    cmake
    cython
    ninja
<<<<<<< HEAD
    oldest-supported-numpy
    scikit-build
    setuptools
    wheel
=======
    numpy
    scikit-build
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    msgpack
    ndindex
    numpy
    py-cpuinfo
    rich
  ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
    torch
  ];

  meta = with lib; {
    description = "Python wrapper for the extremely fast Blosc2 compression library";
    homepage = "https://github.com/Blosc/python-blosc2";
    changelog = "https://github.com/Blosc/python-blosc2/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
