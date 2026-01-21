{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  scipy,
  pytest,
  python,
  pybind11,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pyamg";
  version = "5.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UyPQ8aTNmZviRqkNWAyeHptYS5iIf2KY05dhEIfvhgs=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    numpy
    scipy
    pytest
    pybind11
  ];

  checkPhase = ''
    runHook preCheck

    # The `pyamg` directory in PWD doesn't have the compiled Cython modules in it, but has higher import priority compared to the properly built and installed `pyamg`.
    # It's easier to just remove the package directory in PWD.
    rm -r pyamg
    ${python.interpreter} -c "import pyamg; pyamg.test()"

    runHook postCheck
  '';

  pythonImportsCheck = [
    "pyamg"
    "pyamg.amg_core.evolution_strength"
  ];

  meta = {
    description = "Algebraic Multigrid Solvers in Python";
    homepage = "https://github.com/pyamg/pyamg";
    changelog = "https://github.com/pyamg/pyamg/blob/v${version}/changelog.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
