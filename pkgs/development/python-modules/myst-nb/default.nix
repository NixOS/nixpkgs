{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  flit-core,
  importlib-metadata,
  ipython,
  jupyter-cache,
  nbclient,
  myst-parser,
  nbformat,
  pyyaml,
  sphinx,
  sphinx-togglebutton,
  typing-extensions,
  ipykernel,
}:

buildPythonPackage rec {
  pname = "myst-nb";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "myst_nb";
    hash = "sha256-dCJ8EfdtA0lPQ7d4hlmxYblPTe3vIwopEkEryMPJ5VM=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    importlib-metadata
    ipython
    jupyter-cache
    nbclient
    myst-parser
    nbformat
    pyyaml
    sphinx
    sphinx-togglebutton
    typing-extensions
    ipykernel
  ];

  pythonImportsCheck = [
    "myst_nb"
    "myst_nb.sphinx_ext"
  ];

  meta = with lib; {
    description = "Jupyter Notebook Sphinx reader built on top of the MyST markdown parser";
    homepage = "https://github.com/executablebooks/MyST-NB";
    changelog = "https://github.com/executablebooks/MyST-NB/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
