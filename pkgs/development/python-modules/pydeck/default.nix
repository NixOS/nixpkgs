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
  pythonOlder,
  setuptools,
  traitlets,
  wheel,
}:

buildPythonPackage rec {
  pname = "pydeck";
  version = "0.9.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

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
