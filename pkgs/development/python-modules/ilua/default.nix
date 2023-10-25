{ lib
, buildPythonPackage
, fetchPypi
, jupyter_console
, jupyter-core
, pygments
, termcolor
, txzmq
}:

buildPythonPackage rec {
  pname = "ilua";
  version = "0.2.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YxV6xC7GS5NXyMPRZN9YIJxamgP2etwrZUAZjk5PjtU=";
  };

  propagatedBuildInputs = [
    jupyter_console
    jupyter-core
    pygments
    termcolor
    txzmq
  ];

  # No tests found
  doCheck = false;

  pythonImportsCheck = [ "ilua" ];

  meta = with lib; {
    description = "Portable Lua kernel for Jupyter";
    homepage = "https://github.com/guysv/ilua";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
