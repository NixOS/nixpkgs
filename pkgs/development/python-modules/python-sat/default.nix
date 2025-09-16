{
  buildPythonPackage,
  fetchPypi,
  lib,
  six,
  pypblib,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "python-sat";
  version = "1.8.dev20";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "python_sat";
    hash = "sha256-8uUi6DtPVh/87EWSgTtGq7UhAs+Glw8KARPkK3ukeMg=";
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
