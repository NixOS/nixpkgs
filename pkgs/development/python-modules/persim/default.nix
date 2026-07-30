{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  deprecated,
  hopcroftkarp,
  joblib,
  matplotlib,
  numpy,
  scikit-learn,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "persim";
  version = "0.3.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "persim";
    hash = "sha256-4T0YWEF2uKdk0W1+Vt8I3Mi6ZsazJXoHI0W+O9WbpA0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    deprecated
    hopcroftkarp
    joblib
    matplotlib
    numpy
    scikit-learn
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # specifically needed for darwin
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
  '';

  pythonImportsCheck = [ "persim" ];

  meta = {
    description = "Distances and representations of persistence diagrams";
    homepage = "https://persim.scikit-tda.org";
    changelog = "https://github.com/scikit-tda/persim/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
