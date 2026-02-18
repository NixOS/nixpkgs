{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  build,
  cython,
  findutils,
  pip,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "extension-helpers";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "extension-helpers";
    tag = "v${version}";
    hash = "sha256-coSgaPoz93CqJRb65xYs1sNOwoGhcxWGJF7Jc9N2W1I=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ setuptools ];

  nativeCheckInputs = [
    build
    cython
    findutils
    pip
    pytestCheckHook
    wheel
  ];

  pythonImportsCheck = [ "extension_helpers" ];

  enabledTestPaths = [ "extension_helpers/tests" ];

  disabledTests = [
    # https://github.com/astropy/extension-helpers/issues/43
    "test_write_if_different"
  ];

  meta = {
    description = "Helpers to assist with building Python packages with compiled C/Cython extensions";
    homepage = "https://github.com/astropy/extension-helpers";
    changelog = "https://github.com/astropy/extension-helpers/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
