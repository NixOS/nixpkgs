{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  pyyaml,

  # tests
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jsondiff";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xlwings";
    repo = "jsondiff";
    rev = "refs/tags/${version}";
    hash = "sha256-0EnI7f5t7Ftl/8UcsRdA4iVQ78mxvPucCJjFJ8TMwww=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ pyyaml ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = {
    description = "Diff JSON and JSON-like structures in Python";
    mainProgram = "jdiff";
    homepage = "https://github.com/ZoomerAnalytics/jsondiff";
    license = lib.licenses.mit;
  };
}
