{ attrs
, buildPythonPackage
, cachetools
, cirq-core
, ipython
, ipywidgets
, nbconvert
, nbformat
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cirq-ft";
  inherit (cirq-core) version src meta;

  sourceRoot = "${src.name}/${pname}";

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

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_ft" ];

}
