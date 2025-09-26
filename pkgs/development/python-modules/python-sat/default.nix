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
  version = "1.8.dev21";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "python_sat";
    hash = "sha256-AA8TZS7rcc199BnAqyGGkCRNbgAkyQTG9JVGxVHUdHI=";
  };

  preBuild = ''
    export MAKEFLAGS="-j$NIX_BUILD_CORES"
  '';

  propagatedBuildInputs = [
    six
    pypblib
  ];

  pythonImportsCheck = [
    "pysat"
    "pysat.examples"
    "pysat.allies"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Due to `python -m pytest` appending the local directory to `PYTHONPATH`,
  # importing `pysat.examples` in the tests fails. Removing the `pysat`
  # directory fixes since then only the installed version in `$out` is
  # imported, which has `pysat.examples` correctly installed.
  # See https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    rm -r pysat
  '';

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
