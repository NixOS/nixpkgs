{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  numpy,
  aerosandbox,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage {
  pname = "neuralfoil";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peterdsharpe";
    repo = "NeuralFoil";
    rev = "dde84b617fe5fe1048c9c81068492b220910200a";
    hash = "sha256-iIzbEW+pheG6y2XcidqRkvZ/An//ni8JfySjosDzCRM=";
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
}
