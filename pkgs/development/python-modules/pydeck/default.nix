{
  lib,
  buildPythonPackage,
  fetchPypi,
  ipykernel,
  ipywidgets,
  jinja2,
  jupyter,
  numpy,
  pandas,
  pytestCheckHook,
  setuptools,
  traitlets,
  wheel,
}:

buildPythonPackage rec {
  pname = "pydeck";
  version = "0.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-90R1rmN5UdY/LuWDJnV/jU+c2fKkV89ClQcVAD4stgU=";
  };

  # upstream has an invalid pyproject.toml
  # https://github.com/visgl/deck.gl/issues/8469
  postPatch = ''
    rm pyproject.toml
  '';

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

  optional-dependencies = {
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
  ]
  ++ optional-dependencies.jupyter;

  # tries to start a jupyter server
  disabledTests = [ "test_nbconvert" ];

  meta = {
    homepage = "https://github.com/visgl/deck.gl/tree/master/bindings/pydeck";
    description = "Large-scale interactive data visualization in Python";
    maintainers = with lib.maintainers; [ creator54 ];
    license = lib.licenses.asl20;
  };
}
