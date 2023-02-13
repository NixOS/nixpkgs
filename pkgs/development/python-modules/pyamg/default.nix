{ lib
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, pytest
, pybind11
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pyamg";
  version = "4.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-N608Hcr/JDXCq3yOw2lCrwcmxWPTUFm80Y6wdHP3GC4=";
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

  # failed with "ModuleNotFoundError: No module named 'pyamg.amg_core.evolution_strength'"
  doCheck = false;
  # taken from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=python-pyamg#n27
  # checkPhase = ''
  #   PYTHONPATH="$PWD/build/lib.linux-*:$PYTHONPATH" ${python3.interpreter} -c "import pyamg; pyamg.test()"
  # '';

  pythonImportsCheck = [
    "pyamg"
    "pyamg.amg_core.evolution_strength"
  ];

  meta = with lib; {
    description = "Algebraic Multigrid Solvers in Python";
    homepage = "https://github.com/pyamg/pyamg";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
