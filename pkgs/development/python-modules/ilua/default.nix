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
  format = "pyproject";

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

<<<<<<< HEAD
  meta = {
    description = "Portable Lua kernel for Jupyter";
    mainProgram = "ilua";
    homepage = "https://github.com/guysv/ilua";
    license = lib.licenses.gpl2Only;
=======
  meta = with lib; {
    description = "Portable Lua kernel for Jupyter";
    mainProgram = "ilua";
    homepage = "https://github.com/guysv/ilua";
    license = licenses.gpl2Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
