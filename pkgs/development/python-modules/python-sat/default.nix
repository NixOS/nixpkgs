{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  six,
  pypblib,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "python-sat";
  version = "1.8.dev30";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "python_sat";
    hash = "sha256-KaR6NPD6wzA0WcYzq/ptRFBeI0Pfumz/S2rVlsDKnU4=";
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

  meta = {
    description = "Toolkit for SAT-based prototyping in Python (without optional dependencies)";
    homepage = "https://github.com/pysathq/pysat";
    changelog = "https://pysathq.github.io/updates/";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.marius851000
      lib.maintainers.chrjabs
    ];
    platforms = lib.platforms.all;
  };
})
