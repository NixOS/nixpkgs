{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  bokeh,
  ipython,
  matplotlib,
  nbconvert,
  nbformat,
}:

buildPythonPackage rec {
  pname = "livelossplot";
  version = "0.5.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stared";
    repo = "livelossplot";
    tag = "v${version}";
    hash = "sha256-qC1FBFJyf2IlDIffJ5Xs89WcN/GFA/8maODhc1u2xhA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bokeh
    matplotlib
  ];

  pythonImportsCheck = [ "livelossplot" ];

  nativeCheckInputs = [
    ipython
    nbconvert
    nbformat
    pytestCheckHook
  ];

  meta = {
    description = "Live training loss plot in Jupyter for Keras, PyTorch, and others";
    homepage = "https://github.com/stared/livelossplot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
