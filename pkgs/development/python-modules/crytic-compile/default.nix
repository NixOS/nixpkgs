{
  lib,
  buildPythonPackage,
  cbor2,
  fetchFromGitHub,
  pycryptodome,
  pythonOlder,
  setuptools,
  solc-select,
  toml,
}:

buildPythonPackage rec {
  pname = "crytic-compile";
<<<<<<< HEAD
  version = "0.3.11";
=======
  version = "0.3.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "crytic-compile";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-NVAIVUfh1bizg/HG1z7Ze6o5w6wto744Ogq0LPg0gXg=";
=======
    hash = "sha256-K8s/ocvja3ae8AOw3N8JFVYmrn5QSCzXkGG6Z3V59IE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [
    cbor2
    pycryptodome
    setuptools
    solc-select
    toml
  ];

  # Test require network access
  doCheck = false;

  # required for import check to work
  # PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
  env.HOME = "/tmp";
  pythonImportsCheck = [ "crytic_compile" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Abstraction layer for smart contract build systems";
    mainProgram = "crytic-compile";
    homepage = "https://github.com/crytic/crytic-compile";
    changelog = "https://github.com/crytic/crytic-compile/releases/tag/${src.tag}";
<<<<<<< HEAD
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
=======
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      arturcygan
      hellwolf
    ];
  };
}
