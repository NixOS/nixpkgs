{ buildPythonPackage
, fetchPypi
, lib
, isPy3k

# pythonPackages
, GitPython
, pbr
, pyyaml
, six
, stevedore
}:

buildPythonPackage rec {
  pname = "bandit";
  version = "1.7.4";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LWOoxXNBe64ziWLUubBvvGCA907NlVoJKEnh5lxxe9I=";
  };

  propagatedBuildInputs = [
    GitPython
    pbr
    pyyaml
    six
    stevedore
  ];

  # Framework is Tox, tox performs 'pip install' inside the virtual-env
  #   and this requires Network Connectivity
  doCheck = false;

  meta = {
    description = "Security oriented static analyser for python code";
    homepage = "https://bandit.readthedocs.io/en/latest/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
