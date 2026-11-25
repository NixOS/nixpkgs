{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  numpy,
  scipy,
  pymetis,
  pytest,
  python,
  pybind11,
  meson-python,
  versioningit,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyamg";
  version = "5.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-tYKc45aHZVzmjbRBXJPuFxBWu05B57eY705un5+Tvq4=";
  };

  build-system = [
    meson-python
    pybind11
    numpy
    versioningit
  ];

  dependencies = [
    numpy
    scipy
    pymetis
  ];

  nativeCheckInputs = [
    pytest
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
    changelog = "https://github.com/pyamg/pyamg/blob/v${finalAttrs.version}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stephen-huan ];
    # last successful hydra build on darwin was in 2025
    broken = stdenv.hostPlatform.isDarwin;
  };
})
