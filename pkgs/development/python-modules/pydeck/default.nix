{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, ipywidgets
, pythonOlder
, pytestCheckHook
, pandas
, jinja2
, numpy
, traitlets
}:

buildPythonPackage rec {
  pname = "pydeck";
  version = "0.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B+3egz98/O9nSRJDURlap9zSRmPUkJ/XiY29C2+8Aew=";
  };

  pythonImportsCheck = [ "pydeck" ];

  nativeCheckInputs = [ pytestCheckHook pandas ];

  # tries to start a jupyter server
  disabledTests = [ "test_nbconvert" ];

  propagatedBuildInputs = [
    ipykernel
    ipywidgets
    jinja2
    numpy
    traitlets
  ];

  meta = with lib; {
    homepage = "https://github.com/visgl/deck.gl/tree/master/bindings/pydeck";
    description = "Large-scale interactive data visualization in Python";
    maintainers = with maintainers; [ creator54 ];
    license = licenses.asl20;
  };
}
