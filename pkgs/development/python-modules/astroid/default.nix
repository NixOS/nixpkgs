{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pip,
  pylint,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "astroid";
  version = "4.0.3"; # Check whether the version is compatible with pylint
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "astroid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5p1xY6EWviSgmrLVOx3w7RcG/Vpx+sUtVndoxXrIFTQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pip
    pytestCheckHook
  ];

  disabledTests = [
    # UserWarning: pkg_resources is deprecated as an API. See https://setuptools.pypa.io/en/latest/pkg_resources.html.
    "test_identify_old_namespace_package_protocol"
  ];

  disabledTestPaths = [
    # requires mypy
    "tests/test_raw_building.py"
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
