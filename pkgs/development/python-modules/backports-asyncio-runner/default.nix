{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitHub,
  hatchling,
  hatch-fancy-pypi-readme,
}:

let
  pname = "backports-asyncio-runner";
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "samypr100";
    repo = "backports.asyncio.runner";
    tag = "v${version}";
    hash = "sha256-F8x7MZgu0VItH7kBke7C7+ZBoM6Iyj8xOeQ2t56ff3k=";
  };
in
buildPythonPackage {
  inherit pname version src;
  pyproject = true;

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  pythonImportsCheck = [ "backports.asyncio.runner" ];
  nativeCheckInputs = [ pytestCheckHook ];

  # These tests depend on the test.test_asyncio module in cpython which is
  # removed at build time.
  disabledTestPaths = [
    "tests/test_tasks_py38.py"
    "tests/test_tasks_py39.py"
    "tests/test_tasks_py310.py"
  ];

  meta = {
    changelog = "https://github.com/samypr100/backports.asyncio.runner/releases/tag/${src.tag}";
    description = "Backport of Python 3.11 asyncio.Runner";
    homepage = "https://github.com/samypr100/backports.asyncio.runner";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ detroyejr ];
  };
}
