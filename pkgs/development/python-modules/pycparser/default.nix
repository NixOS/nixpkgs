{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycparser";
  version = "3.00";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eliben";
    repo = "pycparser";
    tag = "release_v${version}";
    hash = "sha256-6eKc+p3xLyRPo3oCWP/dbMpHlkBXLy8XiGR0gTEHI2E=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pycparser" ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "release_v";
  };

  meta = {
    changelog = "https://github.com/eliben/pycparser/releases/tag/${src.tag}";
    description = "C parser in Python";
    homepage = "https://github.com/eliben/pycparser";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
