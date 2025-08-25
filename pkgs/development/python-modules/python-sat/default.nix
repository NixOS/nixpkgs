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
  version = "0.1.8.dev19";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pysathq";
    repo = "pysat";
    rev = "304888546c8474937136efa6d24fe0d200191114"; # upstream does not tag releases
    hash = "sha256-aPyFFQ+ym0Os0Z8xVTSX3NaehxYsclyibSj4MPdJkoU=";
  };

  # Build SAT solver backends in parallel
  postPatch = ''
    substituteInPlace solvers/prepare.py \
      --replace-fail "&& make &&" "&& make -j$NIX_BUILD_CORES &&"
  '';

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
