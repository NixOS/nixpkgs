{ buildPythonPackage
, fetchPypi
, lib

# Python Dependencies
, pythonPackages
}:

buildPythonPackage rec {
  pname = "bandit";
  version = "1.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rb034c99pyhb4a60z7f2kz40cjydhm8m9v2blaal1rmhlam7rs1";
  };

  propagatedBuildInputs = with pythonPackages; [
    GitPython
    pbr
    pyyaml
    six
    stevedore
  ];

  doCheck = false;

  meta = {
    description = "Security oriented static analyser for python code.";
    homepage = "https://bandit.readthedocs.io/en/latest/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
