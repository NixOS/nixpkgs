{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  aerosandbox,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "neuralfoil";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peterdsharpe";
    repo = "NeuralFoil";
    rev = "46cda4041134d1b1794d3a81761d8d3e63f20855";
    hash = "sha256-kbPHPJh8xcIdPYIiaxwYqpfcnYzzDD6F0tG3flR0j3M=";
  };

  build-system = [ setuptools ];
  dependencies = [
    numpy
    aerosandbox
  ];

  pythonImportsCheck = [ "neuralfoil" ];

  nativeBuildInputs = [ pytestCheckHook ];

  meta = {
    description = "Airfoil aerodynamics analysis tool using physics-informed machine learning, in pure Python/NumPy";
    homepage = "https://github.com/peterdsharpe/NeuralFoil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
