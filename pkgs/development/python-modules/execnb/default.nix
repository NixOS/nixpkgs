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
  version = "0.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OTxSgnbKwwb1QQ01Hq1VwVauclbcEdAyR4+/T/wssj8=";
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
