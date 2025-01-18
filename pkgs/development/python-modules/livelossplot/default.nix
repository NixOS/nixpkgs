{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  bokeh,
  ipython,
  matplotlib,
  numpy,
  nbconvert,
  nbformat,
}:

buildPythonPackage rec {
  pname = "livelossplot";
  version = "0.5.6";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "stared";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qC1FBFJyf2IlDIffJ5Xs89WcN/GFA/8maODhc1u2xhA=";
  };

  propagatedBuildInputs = [
    bokeh
    ipython
    matplotlib
    numpy
  ];

  nativeCheckInputs = [
    nbconvert
    nbformat
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Live training loss plot in Jupyter for Keras, PyTorch, and others";
    homepage = "https://github.com/stared/livelossplot";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
