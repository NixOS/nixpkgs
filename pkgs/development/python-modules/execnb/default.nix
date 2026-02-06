{
  lib,
  buildPythonPackage,
  fastcore,
  fetchPypi,
  ipython,
  setuptools,
  traitlets,
}:

buildPythonPackage rec {
  pname = "execnb";
  version = "0.1.18";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VM2WsdFICc7trCjfupL5wW0UFTzRW5RPfWs6jYpCSDM=";
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

  meta = {
    description = "Execute a jupyter notebook, fast, without needing jupyter";
    homepage = "https://github.com/fastai/execnb";
    changelog = "https://github.com/fastai/execnb/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rxiao ];
    mainProgram = "exec_nb";
  };
}
