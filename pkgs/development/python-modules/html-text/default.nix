{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  lxml-html-clean,
  pytestCheckHook,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "html-text";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zytedata";
    repo = "html-text";
    tag = finalAttrs.version;
    hash = "sha256-KLWgdVHGYRiQ61hMNx+Kcx9mE7d/TsBe110TfCe+ejU=";
  };

  build-system = [ hatchling ];

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
