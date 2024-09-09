{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ipywidgets,
  fastcore,
  astunparse,
  watchdog,
  execnb,
  ghapi,
  pyyaml,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "nbdev";
  version = "2.3.29";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N5oO77DiLMzybQiE45mIIfu5DoT3/nR0iejB/SPpWLQ=";
  };


  pythonRelaxDeps = [ "ipywidgets" ];

  build-system = [ setuptools ];

  dependencies = [
    astunparse
    execnb
    fastcore
    ghapi
    ipywidgets
    pyyaml
    watchdog
  ];

  # no real tests
  doCheck = false;

  pythonImportsCheck = [ "nbdev" ];

  meta = with lib; {
    homepage = "https://github.com/fastai/nbdev";
    description = "Create delightful software with Jupyter Notebooks";
    changelog = "https://github.com/fastai/nbdev/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ rxiao ];
  };
}
