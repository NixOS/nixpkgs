{
  lib,
  aiowinreg,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  pycryptodomex,
  pythonOlder,
  setuptools,
  tqdm,
  unicrypto,
}:

buildPythonPackage rec {
  pname = "aesedb";
  version = "0.1.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "aesedb";
    tag = version;
    hash = "sha256-YoeqxYkohAR6RaQYDXt7T00LCQDSb/o/ddxYRDGP/2s=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiowinreg
    colorama
    pycryptodomex
    tqdm
    unicrypto
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "aesedb" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Parser for JET databases";
    mainProgram = "antdsparse";
    homepage = "https://github.com/skelsec/aesedb";
    changelog = "https://github.com/skelsec/aesedb/releases/tag/${version}";
<<<<<<< HEAD
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
