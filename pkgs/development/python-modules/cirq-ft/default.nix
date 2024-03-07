{ attrs
, buildPythonPackage
, cachetools
, cirq-core
, ipython
, ipywidgets
, nbconvert
, nbformat
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "cirq-ft";
  pyproject = true;
  inherit (cirq-core) version src meta;

  sourceRoot = "${src.name}/${pname}";

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    attrs
    cachetools
    cirq-core
    ipython
    ipywidgets
    nbconvert
    nbformat
  ];

  nativeCheckInputs = [
    ipython
    pytestCheckHook
  ];

  disabledTests = [
    # Upstream doesn't always adjust the version
    "test_version"
  ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_ft" ];

}
