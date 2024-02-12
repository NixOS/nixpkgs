{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, ipywidgets
, jinja2
, jupyter
, numpy
, pandas
, pytestCheckHook
, pythonOlder
, setuptools
, traitlets
, wheel
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

  nativeBuildInputs = [
    jinja2
    jupyter
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    jinja2
    numpy
  ];

  passthru.optional-dependencies = {
    carto = [
      # pydeck-carto
    ];
    jupyter = [
      ipykernel
      ipywidgets
      traitlets
    ];
  };

  pythonImportsCheck = [ "pydeck" ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
  ] ++ passthru.optional-dependencies.jupyter;

  # tries to start a jupyter server
  disabledTests = [ "test_nbconvert" ];

  meta = with lib; {
    homepage = "https://github.com/visgl/deck.gl/tree/master/bindings/pydeck";
    description = "Large-scale interactive data visualization in Python";
    maintainers = with maintainers; [ creator54 ];
    license = licenses.asl20;
  };
}
