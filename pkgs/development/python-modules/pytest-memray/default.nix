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
    changelog = "https://github.com/bloomberg/pytest-memray/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
