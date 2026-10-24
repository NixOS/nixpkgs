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
  version = "0.4.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "persim";
    hash = "sha256-1E0ZwYaZFlxd61IlIAIH9igvvx77kMjauEV0710k+AY=";
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
