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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyamg";
  version = "5.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+Q+d55W04pWJ7dLrRG0R3bRmZ46+gj7TKfzzV1nqOQw=";
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

  meta = with lib; {
    description = "Algebraic Multigrid Solvers in Python";
    homepage = "https://github.com/pyamg/pyamg";
    changelog = "https://github.com/pyamg/pyamg/blob/v${version}/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
