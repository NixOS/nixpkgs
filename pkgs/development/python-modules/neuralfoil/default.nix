{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  numpy,
  aerosandbox,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "neuralfoil";
  version = "0.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-mELkbPtOVQ7t0GX7gnPUv9OzDTZIBUEHsnQJQDjA7S8=";
  };

  build-system = [ hatchling ];
  dependencies = [
    numpy
    aerosandbox
  ];

  pythonImportsCheck = [ "neuralfoil" ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Airfoil aerodynamics analysis tool using physics-informed machine learning, in pure Python/NumPy";
    homepage = "https://github.com/peterdsharpe/NeuralFoil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
