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
  version = "0.1.12";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZZMoB4AI2un09nNVWKp9zkcJRMHH1lSYjcMp6d0p+d8=";
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
