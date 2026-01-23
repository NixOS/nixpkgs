{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  torch,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "geotorch";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lezcano";
    repo = "geotorch";
    tag = version;
    hash = "sha256-kkn0PZzQRodXCeX3RcajVvrp1TrhSVgKYwyJGAMuvLM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    torch
  ];

  pythonImportsCheck = [ "geotorch" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Constrained optimization toolkit for PyTorch";
    homepage = "https://github.com/lezcano/geotorch";
    changelog = "https://github.com/lezcano/geotorch/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
