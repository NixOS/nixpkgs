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
  version = "4.2";
  pyproject = true;

  # https://github.com/regebro/pyroma/issues/104
  disabled = pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "regebro";
    repo = "pyroma";
    rev = version;
    sha256 = "sha256-ElSw+bY6fbHJPTX7O/9JZ4drttfbUQsU/fv3Cqqb/J4=";
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

  meta = with lib; {
    description = "Test your project's packaging friendliness";
    mainProgram = "pyroma";
    homepage = "https://github.com/regebro/pyroma";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
