{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  flaky,
  hatchling,
  hatch-vcs,
  memray,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-memray";
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = "pytest-memray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BDJsEtC5vdXzBFhZ31j5xY+XUDXG0IMdIo4G/TLtZck=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ memray ];

  nativeCheckInputs = [
    anyio
    flaky
    pytest-xdist
    pytestCheckHook
  ];

  enabledTestPaths = [
    # don't run the demo tests
    "tests"
  ];

  disabledTestPaths = [
    "tests/test_pytest_memray.py::test_bin_path_prefix" # AssertionError: assert False
    "tests/test_pytest_memray.py::test_bin_path" # AssertionError: Expected 'uuid4' to have been called once. Called 4 times.
    "tests/test_pytest_memray.py::test_memray_report_with_pytest_xdist" # AssertionError: assert 'results for test_memray_report_with_pytest_xdist.py...
  ];

  pythonImportsCheck = [ "pytest_memray" ];

  meta = {
    description = "Pytest plugin for easy integration of memray memory profiler";
    homepage = "https://github.com/bloomberg/pytest-memray";
    changelog = "https://github.com/bloomberg/pytest-memray/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
