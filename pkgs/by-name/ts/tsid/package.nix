{
  eiquadprog,
  fetchFromGitHub,
  jrl-cmakemodules,
  lib,
  osqp-eigen,
  pinocchio,
  proxsuite,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tsid";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "tsid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f/SecQfEmrlelVR5584KIHFwwrp5Cy2aBMKI/rxuPmc=";
  };

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
    (lib.cmakeBool "BUILD_WITH_OSQP" true)
    (lib.cmakeBool "BUILD_WITH_PROXQP" true)
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
  ];

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

  buildInputs = [
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    eiquadprog
    osqp-eigen
    pinocchio
    proxsuite
  ];

  doCheck = true;

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Efficient Task Space Inverse Dynamics (TSID) based on Pinocchio";
    homepage = "https://github.com/stack-of-tasks/tsid";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
