{ lib
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, pytest
<<<<<<< HEAD
, python
, pybind11
, setuptools-scm
, pythonOlder
=======
, pybind11
, setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pyamg";
<<<<<<< HEAD
  version = "5.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XwSKAXQzQ64NTIYjBgBzhs+5sURTxHrf2tJ363mkbVA=";
=======
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6rlnIo9hQ0LOI8e01rvKJa2LknpFy3Ym0e8XyfBioC4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    pytest
    pybind11
  ];

<<<<<<< HEAD
  checkPhase = ''
    runHook preCheck

    # The `pyamg` directory in PWD doesn't have the compiled Cython modules in it, but has higher import priority compared to the properly built and installed `pyamg`.
    # It's easier to just remove the package directory in PWD.
    rm -r pyamg
    ${python.interpreter} -c "import pyamg; pyamg.test()"

    runHook postCheck
  '';
=======
  # failed with "ModuleNotFoundError: No module named 'pyamg.amg_core.evolution_strength'"
  doCheck = false;
  # taken from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=python-pyamg#n27
  # checkPhase = ''
  #   PYTHONPATH="$PWD/build/lib.linux-*:$PYTHONPATH" ${python3.interpreter} -c "import pyamg; pyamg.test()"
  # '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "pyamg"
    "pyamg.amg_core.evolution_strength"
  ];

  meta = with lib; {
    description = "Algebraic Multigrid Solvers in Python";
    homepage = "https://github.com/pyamg/pyamg";
<<<<<<< HEAD
    changelog = "https://github.com/pyamg/pyamg/blob/v${version}/changelog.md";
    license = licenses.mit;
    maintainers = [ ];
=======
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
