{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gemmi,
  numpy,
  pytestCheckHook,
  pythonOlder,
  rdkit,
  scipy,
}:

buildPythonPackage rec {
  pname = "meeko";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "forlilab";
    repo = "Meeko";
    tag = "v${version}";
    hash = "sha256-ViIBiczwxTwraYn8UnFAZFCFT28v3WEYm04W2YpU/4g=";
  };

  propagatedBuildInputs = [
    # setup.py only requires numpy but others are needed at runtime
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
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
