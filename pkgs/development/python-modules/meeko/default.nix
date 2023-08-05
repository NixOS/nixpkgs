{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
, rdkit
, scipy
}:

buildPythonPackage rec {
  pname = "meeko";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "forlilab";
    repo = "Meeko";
    rev = "refs/tags/v${version}";
    hash = "sha256-BCkKRwz3jK5rNAMtKcGxuvfdIFxRRJpABcedyd1zSKE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "python_requires='>=3.5.*'" "python_requires='>=3.5'"
  '';

  propagatedBuildInputs = [
    # setup.py only requires numpy but others are needed at runtime
    numpy
    rdkit
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "meeko"
  ];

  meta = {
    description = "Python package for preparing small molecule for docking";
    homepage = "https://github.com/forlilab/Meeko";
    changelog = "https://github.com/forlilab/Meeko/releases/tag/${src.rev}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
