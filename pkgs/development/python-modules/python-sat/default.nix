{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  six,
  pypblib,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "python-sat";
<<<<<<< HEAD
  version = "1.8.dev25";
=======
  version = "1.8.dev24";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit version;
    pname = "python_sat";
<<<<<<< HEAD
    hash = "sha256-3eVCBXg95RyzMA8O8EOss1FKh+1EofnkKYJcVNuQAzY=";
=======
    hash = "sha256-f9NnaPcHdNNInWTvpkg91ieaYejJ29kAAOLcbnbDmM0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Toolkit for SAT-based prototyping in Python (without optional dependencies)";
    homepage = "https://github.com/pysathq/pysat";
    changelog = "https://pysathq.github.io/updates/";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.marius851000
      lib.maintainers.chrjabs
=======
  meta = with lib; {
    description = "Toolkit for SAT-based prototyping in Python (without optional dependencies)";
    homepage = "https://github.com/pysathq/pysat";
    changelog = "https://pysathq.github.io/updates/";
    license = licenses.mit;
    maintainers = [
      maintainers.marius851000
      maintainers.chrjabs
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
    platforms = lib.platforms.all;
  };
}
