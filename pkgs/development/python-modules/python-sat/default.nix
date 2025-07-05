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
  version = "0.1.8.dev17";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pysathq";
    repo = "pysat";
    rev = "a04763de6dafb8d3a0d7f1b231fc0d30be1de4c0"; # upstream does not tag releases
    hash = "sha256-FG6oAAI8XKXumj6Ys2QjjYcRp1TpwkUZzyfpkdq5V6E=";
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
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin ++ [ "i686-linux" ];
  };
}
