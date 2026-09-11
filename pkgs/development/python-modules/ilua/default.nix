{
  lib,
  buildPythonPackage,
  fetchPypi,
  jupyter-console,
  jupyter-core,
  pygments,
  setuptools,
  termcolor,
  txzmq,
}:

buildPythonPackage rec {
  pname = "ilua";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YxV6xC7GS5NXyMPRZN9YIJxamgP2etwrZUAZjk5PjtU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    jupyter-console
    jupyter-core
    pygments
    termcolor
    txzmq
  ];

  # No tests found
  doCheck = false;

  pythonImportsCheck = [ "ilua" ];

  meta = {
    description = "Portable Lua kernel for Jupyter";
    mainProgram = "ilua";
    homepage = "https://github.com/guysv/ilua";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
}
