{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  six,
  pypblib,
  pytestCheckHook,
  fetchurl,
}:
let
  kissat404src = fetchurl {
    url = "https://github.com/arminbiere/kissat/archive/refs/tags/rel-4.0.4.tar.gz";
    hash = "sha256-v+k+qmMjtIAR5LH890s/LiD53lRHZ+coAJ5bIBgpYZM=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "python-sat";
  version = "1.9.dev2";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "python_sat";
    hash = "sha256-JntHdC4xhDVt8uzZzMn7bmIkMFjrwlZWBs8z0E4WeeU=";
  };

  # The kissat source archive is not included in the repo and pysat attempts to
  # download it at build time. We therefore prefetch and link it.
  prePatch = ''
    ln -s ${kissat404src} solvers/kissat404.tar.gz
  '';

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
