{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  flaky,
  hatchling,
  hatch-vcs,
  memray,
  pytest,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-memray";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = "pytest-memray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-73Lyy14t2Hcqo0aTlWbGMzaxJ73bKjzc4BFE/jPG99I=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ memray ];

  buildInputs = [ pytest ];

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

  pythonImportsCheck = [ "pytest_memray" ];

  meta = {
    description = "Pytest plugin for easy integration of memray memory profiler";
    homepage = "https://github.com/bloomberg/pytest-memray";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
