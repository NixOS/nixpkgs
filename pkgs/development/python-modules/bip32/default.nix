{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  base58,
  coincurve,
}:

buildPythonPackage rec {
  pname = "bip32";
<<<<<<< HEAD
  version = "5.0";
=======
  version = "3.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.9";

  # the PyPi source distribution ships a broken setup.py, so use github instead
  src = fetchFromGitHub {
    owner = "darosior";
    repo = "python-bip32";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-QO1gS9bx/eQPaLuB1ZNZuXj4DmeO4/La2hG9NCXjd+4=";
=======
    hash = "sha256-o8UKR17XDWp1wTWYeDL0DJY+D11YI4mg0UuGEAPkHxE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonRelaxDeps = [ "coincurve" ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    base58
    coincurve
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bip32" ];

<<<<<<< HEAD
  meta = {
    description = "Minimalistic implementation of the BIP32 key derivation scheme";
    homepage = "https://github.com/darosior/python-bip32";
    changelog = "https://github.com/darosior/python-bip32/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ arcnmx ];
=======
  meta = with lib; {
    description = "Minimalistic implementation of the BIP32 key derivation scheme";
    homepage = "https://github.com/darosior/python-bip32";
    changelog = "https://github.com/darosior/python-bip32/blob/${version}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ arcnmx ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
