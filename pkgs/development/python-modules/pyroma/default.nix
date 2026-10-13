{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  build,
  docutils,
  flit-core,
  packaging,
  pygments,
  requests,
  trove-classifiers,

  # test
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyroma";
  version = "5.0.1";
  pyproject = true;

  # https://github.com/regebro/pyroma/issues/104
  disabled = pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "regebro";
    repo = "pyroma";
    tag = version;
    sha256 = "sha256-J5+/1jc/Dvh7aPV9FgG/uhxWG4DbQISgx+kX4Ayd1cU=";
  };

  propagatedBuildInputs = [
    build
    docutils
    flit-core
    packaging
    pygments
    setuptools
    requests
    trove-classifiers
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # tries to reach pypi
    "test_complete"
    "test_distribute"
  ];

  pythonImportsCheck = [ "pyroma" ];

  meta = {
    description = "Test your project's packaging friendliness";
    mainProgram = "pyroma";
    homepage = "https://github.com/regebro/pyroma";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
