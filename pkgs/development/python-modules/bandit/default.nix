{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pythonOlder
, gitpython
, pbr
, pyyaml
, rich
, stevedore
}:

buildPythonPackage rec {
  pname = "bandit";
  version = "1.7.6";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cs57yXQTdNlvsvHJqJYIKYhfEkP/3nQ95woZzuNT6PM=";
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
