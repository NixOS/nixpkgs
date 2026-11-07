{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  passagemath-setup,
  passagemath-environment,
  passagemath-objects,
  ipykernel,
  ipython,
  ipywidgets,
  jupyter-client,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "passagemath-repl";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    passagemath-setup
    passagemath-environment
  ];
  dependencies = [
    passagemath-objects
    passagemath-environment
    ipykernel
    ipython
    ipywidgets
    jupyter-client
    typing-extensions
  ];

  src = fetchPypi {
    pname = "passagemath_repl";
    inherit version;
    hash = "sha256-LkfqLoA7BAzWj0M7aUpWczCWQx/MXobupXtW5HvV0mg=";
  };

  pythonImportsCheck = [ "sage.repl.preparse" ];
}
