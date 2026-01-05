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
  version = "1.9.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MkEEFc2Tv5yLkZchWdXPHn8GOpFG1wNFZBzTh33jSM4=";
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

  meta = with lib; {
    description = "Security oriented static analyser for python code";
    homepage = "https://bandit.readthedocs.io/";
    changelog = "https://github.com/PyCQA/bandit/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
