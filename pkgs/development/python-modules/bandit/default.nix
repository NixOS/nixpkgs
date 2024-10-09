{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  gitpython,
  pbr,
  pyyaml,
  rich,
  stevedore,
}:

buildPythonPackage rec {
  pname = "bandit";
  version = "1.7.10";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-We1cr12Stq2kv2W8ZDf+6kqdoQkzhERf7U1HKsxs/3s=";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    gitpython
    pyyaml
    rich
    stevedore
  ];

  # Framework is Tox, tox performs 'pip install' inside the virtual-env
  #   and this requires Network Connectivity
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
