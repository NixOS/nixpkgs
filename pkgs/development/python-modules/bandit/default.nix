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
  version = "1.6.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rb034c99pyhb4a60z7f2kz40cjydhm8m9v2blaal1rmhlam7rs1";
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
