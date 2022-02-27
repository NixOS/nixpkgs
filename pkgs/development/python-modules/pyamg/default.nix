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
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "48d9be622049d8363cda84125c45d18b89e0ab7d99be5a93c0246f375ebad344";
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
