{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, deprecated
, hopcroftkarp
, joblib
, matplotlib
, numpy
, scikit-learn
, scipy
, pytestCheckHook
, pythonAtLeast
, pythonOlder
}:

buildPythonPackage rec {
  pname = "persim";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7w8KJHrc9hBOysFBF9sLJFgXEOqKjZZIFoBTlXALSXU=";
  };

  propagatedBuildInputs = [
    deprecated
    hopcroftkarp
    joblib
    matplotlib
    numpy
    scikit-learn
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # specifically needed for darwin
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
  '';

  pythonImportsCheck = [
    "persim"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # AttributeError: module 'collections' has no attribute 'Iterable'
    "test_empyt_diagram_list"
    "test_empty_diagram_list"
    "test_fit_diagram"
    "test_integer_diagrams"
    "test_lists_of_lists"
    "test_mixed_pairs"
    "test_multiple_diagrams"
    "test_n_pixels"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Distances and representations of persistence diagrams";
    homepage = "https://persim.scikit-tda.org";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
