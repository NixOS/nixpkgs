{
  lib,
  buildPythonPackage,
  fetchPypi,
  ipykernel,
  jupyter-core,
  jupyter-client,
  ipython-genutils,
  pygments,
  pyqt5,
  pytestCheckHook,
  pythonOlder,
  pyzmq,
  qtpy,
  setuptools,
  traitlets,
}:

buildPythonPackage rec {
  pname = "qtconsole";
  version = "5.5.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a1+xEnSyl0Y3Bq+E3LvVySJzsfYZ5tJdCIdLCohRaYk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ipykernel
    ipython-genutils
    jupyter-core
    jupyter-client
    pygments
    pyqt5
    pyzmq
    qtpy
    traitlets
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # : cannot connect to X server
  doCheck = false;

  pythonImportsCheck = [ "qtconsole" ];

  meta = with lib; {
    description = "Jupyter Qt console";
    mainProgram = "jupyter-qtconsole";
    homepage = "https://qtconsole.readthedocs.io/";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
