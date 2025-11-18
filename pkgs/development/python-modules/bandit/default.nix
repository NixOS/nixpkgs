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
  version = "1.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bbr9GlHiduBlQE8GmA1iS60UI0Ta6sOwhRIfz9EXt88=";
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
