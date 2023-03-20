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
  version = "1.7.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vfxzm6oDuIDC0V0EMbMcZY/8NI6Qf+GX5U4Did1Z4R4=";
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
