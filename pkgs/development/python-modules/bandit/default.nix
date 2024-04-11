{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, gitpython
, pbr
, pyyaml
, rich
, stevedore
}:

buildPythonPackage rec {
  pname = "bandit";
  version = "1.7.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nt5Q9yCFarJKJNuqX+4sZgUO2XwUd+ChFZ3qsXdeq2s=";
  };

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    gitpython
    pyyaml
    rich
    stevedore
  ];

  # Framework is Tox, tox performs 'pip install' inside the virtual-env
  #   and this requires Network Connectivity
  doCheck = false;

  pythonImportsCheck = [
    "bandit"
  ];

  meta = with lib; {
    description = "Security oriented static analyser for python code";
    homepage = "https://bandit.readthedocs.io/";
    changelog = "https://github.com/PyCQA/bandit/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
