{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "propka";
  version = "3.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jensengroup";
    repo = "propka";
    rev = "refs/tags/v${version}";
    hash = "sha256-NbvrlapBALGbUyBqdqDcDG/igDf/xqxC35DzVUrbHlo=";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "propka"
  ];

  meta = with lib; {
    description = "A predictor of the pKa values of ionizable groups in proteins and protein-ligand complexes based in the 3D structure";
    homepage = "https://github.com/jensengroup/propka";
    changelog = "https://github.com/jensengroup/propka/releases/tag/v${version}";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ natsukium ];
  };
}
