{
  base58,
  buildPythonPackage,
  cashaddress,
  fetchPypi,
  lib,
  pbkdf2,
  pyperclip,
  pythonRelaxDepsHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycryptotools";
  version = "0.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zfXHvEaSlDXAeKnmymytRt5Z6fBG/RH5R7j5ieg3rAU=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [ "requests" ]; # pycryptotools request requests~=2.32.3 which is older than the one in nixpkgs

  dependencies = [
    pbkdf2
    requests
    cashaddress
    pyperclip
    base58
  ];

  pythonImportsCheck = [ "pycryptotools" ];

  meta = {
    description = "Python library for Crypto coins signatures and transactions";
    homepage = "https://pypi.org/project/pycryptotools/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eymeric ];
  };
}
