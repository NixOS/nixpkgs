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
  version = "0.1.8.dev20";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pysathq";
    repo = "pysat";
    rev = "d94f51e5eff2feef35abbc25480659eafa615cc0"; # upstream does not tag releases
    hash = "sha256-fKZcdEVuqpv8jWnK8Cr1UJ7szJqXivK6x3YPYHH5ccI=";
  };

  # Build SAT solver backends in parallel and fix hard-coded g++ reference for
  # darwin, where stdenv uses clang
  postPatch = ''
    substituteInPlace solvers/prepare.py \
      --replace-fail "&& make &&" "&& make -j$NIX_BUILD_CORES &&"
    substituteInPlace solvers/patches/glucose421.patch \
      --replace-fail "+CXX      := g++" "+CXX      := c++"
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
  };
}
