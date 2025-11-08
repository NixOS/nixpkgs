{
  cmake,
  doxygen,
  eiquadprog,
  fetchFromGitHub,
  lib,
  osqp-eigen,
  pkg-config,
  pinocchio,
  proxsuite,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tsid";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "tsid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-enSYneV/Av7lF8ADdLqU1Wj2z8/ePocgecFtOBXS0EY=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
    (lib.cmakeBool "BUILD_WITH_OSQP" true)
    (lib.cmakeBool "BUILD_WITH_PROXQP" true)
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
  ];

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    doxygen
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [
    eiquadprog
    osqp-eigen
    pinocchio
    proxsuite
  ];

  doCheck = true;

  meta = {
    description = "Efficient Task Space Inverse Dynamics (TSID) based on Pinocchio";
    homepage = "https://github.com/stack-of-tasks/tsid";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
