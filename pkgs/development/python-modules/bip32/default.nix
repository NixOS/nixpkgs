{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  base58,
  coincurve,
}:

buildPythonPackage rec {
  pname = "bip32";
  version = "5.0";
  pyproject = true;

  # the PyPi source distribution ships a broken setup.py, so use github instead
  src = fetchFromGitHub {
    owner = "darosior";
    repo = "python-bip32";
    rev = version;
    hash = "sha256-QO1gS9bx/eQPaLuB1ZNZuXj4DmeO4/La2hG9NCXjd+4=";
  };

  pythonRelaxDeps = [ "coincurve" ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    base58
    coincurve
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bip32" ];

  meta = {
    description = "Minimalistic implementation of the BIP32 key derivation scheme";
    homepage = "https://github.com/darosior/python-bip32";
    changelog = "https://github.com/darosior/python-bip32/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ arcnmx ];
  };
}
