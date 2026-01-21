{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  lxml-html-clean,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "html-text";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zytedata";
    repo = "html-text";
    tag = version;
    hash = "sha256-KLWgdVHGYRiQ61hMNx+Kcx9mE7d/TsBe110TfCe+ejU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    lxml-html-clean
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "html_text" ];

  meta = {
    description = "Extract text from HTML";
    homepage = "https://github.com/zytedata/html-text";
    changelog = "https://github.com/zytedata/html-text/blob/${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
