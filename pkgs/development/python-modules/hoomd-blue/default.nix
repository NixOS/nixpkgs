{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  overrideSDK,
  cmake,
  mpiCheckPhaseHook,
  pkgconfig,
  pytestCheckHook,
  python,
  cereal,
  eigen,
  mpi,
  mpi4py,
  numpy,
  pybind11,
  rowan,
}:

let
  components = {
    cgcmm = true;
    depreciated = true;
    hpmc = true;
    md = true;
    metal = true;
  };
  withMPI = (mpi != null);
  # Workaround error: aligned deallocation function is only available on macOS 10.13 or newer
  stdenvOverridden =
    if stdenv.isDarwin then
      overrideSDK stdenv {
        darwinSdkVersion = "11.0";
        darwinMinVerlsion = "10.13";
      }
    else
      stdenv;
in
(buildPythonPackage rec {
  stdenv = stdenvOverridden;

  version = "4.8.2";
  pname = "hoomd-blue";
  pyproject = false; # Built with cmake

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "hoomd-blue";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-TpShA3tP2gJ8y/A5Mx9QRoBGadiSdGnsZLVHcV3LvBQ=";
  };

  passthru = {
    inherit components mpi;
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  buildInputs = [
    cereal
    eigen
    mpi
  ];

  dependencies = [
    numpy
    pybind11
  ] ++ lib.optionals withMPI [ mpi4py ];

  dontAddPrefix = true;

  # Workaround CMake's need to find MPI-related executables
  strictDeps = false;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_MPI" withMPI)
    (lib.cmakeBool "BUILD_CGCMM" components.cgcmm)
    (lib.cmakeBool "BUILD_DEPRECIATED" components.depreciated)
    (lib.cmakeBool "BUILD_HPMC" components.hpmc)
    (lib.cmakeBool "BUILD_MD" components.md)
    (lib.cmakeBool "BUILD_METAL" components.metal)
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/${python.sitePackages}"
  ];

  # For buildPythonPackage,
  # checkPhase means installCheckPhase
  # and so does checkInputs, preCheck, etc.
  checkInputs = [ rowan ];

  nativeCheckInputs = [
    mpiCheckPhaseHook
    pytestCheckHook
  ];

  pytestFlagsArray = [ "hoomd" ];

  pythonImportsCheck = [ "hoomd" ];

  meta = with lib; {
    homepage = "http://glotzerlab.engin.umich.edu/hoomd-blue/";
    description = "HOOMD-blue is a general-purpose particle simulation toolkit";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}).overrideAttrs
  (
    finalAttrs: previousAttrs: {
      # This project is built with CMake, which provides C++ tests.
      # This means the actual doCheck (disabled by buildPythonPackage)
      # and checkPhase (Make-based test defined by pkgs/stdenv/generic/setup.sh).
      doCheck = true;
    }
  )
