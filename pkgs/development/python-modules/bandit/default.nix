{
  lib,
  buildPythonPackage,
  fetchPypi,
  gitpython,
  pbr,
  pyyaml,
  rich,
  stevedore,
}:

buildPythonPackage rec {
  pname = "bandit";
  version = "1.9.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-reS5t3hvie9vxzRKUrNFWMrsXadMuQNzrtAd6IRy93Q=";
  };

  build-system = [ pbr ];

  dependencies = [
    gitpython
    pyyaml
    rich
    stevedore
  ];

  # Framework is Tox, tox performs 'pip install' inside the virtual-env
  # and this requires Network Connectivity
  doCheck = false;

  pythonImportsCheck = [ "bandit" ];

  meta = {
    description = "Security oriented static analyser for python code";
    homepage = "https://bandit.readthedocs.io/";
    changelog = "https://github.com/PyCQA/bandit/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
