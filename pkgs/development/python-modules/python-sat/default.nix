{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  six,
  pypblib,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "python-sat";
  version = "0.1.8.dev16";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pysathq";
    repo = "pysat";
    rev = "e6a6a2bf78aa7ad806f47a84aecd1b7bfd5b3b89"; # upstream does not tag releases
    hash = "sha256-6RX57eAyWypbJFCXxTWJNmjIXwbB7ruJtksDOXzSWo0=";
  };

  propagatedBuildInputs = [
    six
    pypblib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "tests/test_unique_mus.py" ];

  meta = with lib; {
    description = "Toolkit to provide interface for various SAT (without optional dependancy py-aiger-cnf)";
    homepage = "https://github.com/pysathq/pysat";
    changelog = "https://pysathq.github.io/updates/";
    license = licenses.mit;
    maintainers = [
      maintainers.marius851000
      maintainers.chrjabs
    ];
  };
}
