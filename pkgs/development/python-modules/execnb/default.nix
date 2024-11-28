{
  lib,
  buildPythonPackage,
  fastcore,
  fetchPypi,
  ipython,
  pythonOlder,
  setuptools,
  traitlets,
}:

buildPythonPackage rec {
  pname = "execnb";
  version = "0.1.8";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZPSuqIkSVnmAA1HYNMUOTw+5Al9hKxo0ZQPvnVshgxI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fastcore
    ipython
    traitlets
  ];

  # no real tests
  doCheck = false;

  pythonImportsCheck = [ "execnb" ];

  meta = with lib; {
    description = "Execute a jupyter notebook, fast, without needing jupyter";
    homepage = "https://github.com/fastai/execnb";
    changelog = "https://github.com/fastai/execnb/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ rxiao ];
    mainProgram = "exec_nb";
  };
}
