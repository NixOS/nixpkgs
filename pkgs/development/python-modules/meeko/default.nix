{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gemmi,
  numpy,
  pytestCheckHook,
  rdkit,
  scipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "meeko";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "forlilab";
    repo = "Meeko";
    tag = "v${version}";
    hash = "sha256-ViIBiczwxTwraYn8UnFAZFCFT28v3WEYm04W2YpU/4g=";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = [
    "gemmi"
    "rdkit"
  ];

  dependencies = [
    gemmi
    numpy
    rdkit
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "meeko" ];

  meta = {
    description = "Python package for preparing small molecule for docking";
    homepage = "https://github.com/forlilab/Meeko";
    changelog = "https://github.com/forlilab/Meeko/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
