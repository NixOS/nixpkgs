{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  cython,
  setuptools,
  mpi,
  openssh,
  pytestCheckHook,
  mpiCheckPhaseHook,
}:

buildPythonPackage rec {
  pname = "mpi4py";
  # See https://github.com/mpi4py/mpi4py/issues/386 . Part of the changes since
  # the last release include Python 3.12 fixes.
  version = "3.1.6-unstable-2024-07-08";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "mpi4py";
    owner = "mpi4py";
    rev = "e9a59719bbce1b9c351e1e30ecd3be3b459e97cd";
    hash = "sha256-C/nidWGr8xsLV73u7HRtnXoQgYmoRJkD45DFrdXXTPI=";
  };

  build-system = [
    cython
    setuptools
    mpi
  ];
  dependencies = [
    mpi
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    openssh
    mpiCheckPhaseHook
  ];
  # Most tests pass, (besides `test_spawn.py`), but when reaching ~80% tests
  # progress, an orted process hangs and the tests don't finish. This issue is
  # probably due to the sandbox.
  doCheck = false;
  disabledTestPaths = [
    # Almost all tests in this file fail (TODO: Report about this upstream..)
    "test/test_spawn.py"
  ];

  passthru = {
    inherit mpi;
  };

  meta = {
    description = "Python bindings for the Message Passing Interface standard";
    homepage = "https://github.com/mpi4py/mpi4py";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
