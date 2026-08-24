{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  einops,
  matplotlib,
  nibabel,
  numpy,
  pystrum,
  scipy,
  torch,
  tqdm,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "neurite";
  version = "0.3-unstable-2025-12-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adalca";
    repo = "neurite";
    rev = "bd8f4153382f043b11887840ceff8ae0db3a83e6";
    hash = "sha256-KFNuT1RYXgIQWz56eyK55yDA8JqucSviJChUO9/JSLY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    einops
    matplotlib
    nibabel
    numpy
    pystrum
    scipy
    torch
    tqdm
  ];

  pythonImportsCheck = [ "neurite" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Neural networks toolbox focused on medical image analysis";
    homepage = "https://github.com/adalca/neurite";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
