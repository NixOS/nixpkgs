{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "opytimark";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gugarosa";
    repo = "opytimark";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FxULG9qiMrdwJBzjrdRs+uzj5d1TmQ8qQcJNA8zo+6c=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  # numpy is not available in the test subprocess
  disabledTests = [
    "test_zip_import_handles_present_and_missing_resources"
  ];

  pythonImportsCheck = [ "opytimark" ];

  meta = {
    description = "Library consisting of optimization benchmarking functions";
    homepage = "https://github.com/gugarosa/opytimark";
    changelog = "https://github.com/gugarosa/opytimark/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ firefly-cpp ];
  };
})
