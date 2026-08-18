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
  version = "1.9.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tYnl3ir+cL1NU/oMHaYZn0CFr2Zv3gDooDTxUqUs1ig=";
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
