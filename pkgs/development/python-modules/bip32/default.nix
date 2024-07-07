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
  version = "3.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  # the PyPi source distribution ships a broken setup.py, so use github instead
  src = fetchFromGitHub {
    owner = "darosior";
    repo = "python-bip32";
    rev = version;
    hash = "sha256-o8UKR17XDWp1wTWYeDL0DJY+D11YI4mg0UuGEAPkHxE=";
  };

  # https://github.com/darosior/python-bip32/pull/40/files
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace-fail 'coincurve>=15.0,<19' 'coincurve>=15.0,<20'
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    base58
    coincurve
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bip32" ];

  meta = with lib; {
    description = "Minimalistic implementation of the BIP32 key derivation scheme";
    homepage = "https://github.com/darosior/python-bip32";
    changelog = "https://github.com/darosior/python-bip32/blob/${version}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ arcnmx ];
  };
}
