{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pylint,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "astroid";
  version = "4.1.2"; # Check whether the version is compatible with pylint
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "astroid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ADLAkPmLtiPx+7b9o0OLawupCtcAmT/jBdv7jqkWqBM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru.tests = {
    inherit pylint;
  };

  meta = {
    changelog = "https://github.com/PyCQA/astroid/blob/${finalAttrs.src.tag}/ChangeLog";
    description = "Abstract syntax tree for Python with inference support";
    homepage = "https://github.com/PyCQA/astroid";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
