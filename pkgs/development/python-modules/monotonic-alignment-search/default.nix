{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  cython,
  numpy,

  # dependencies
  torch,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "monotonic-alignment-search";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eginhard";
    repo = "monotonic_alignment_search";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XsQDRsgwwlZAmxpsISgNYbrgnMOQIVNvzJV4ZWxswCY=";
  };

  build-system = [
    setuptools
    cython
    numpy
  ];

  dependencies = [
    numpy
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "monotonic_alignment_search" ];

  meta = {
    homepage = "https://github.com/eginhard/monotonic_alignment_search";
    description = "Monotonically align text and speech";
    changelog = "https://github.com/eginhard/monotonic_alignment_search/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jbgi ];
  };
})
