{
  lib,
  asyauth,
  asysocks,
  buildPythonPackage,
  colorama,
  cryptography,
  fetchPypi,
  minikerberos,
  prompt-toolkit,
  pycryptodomex,
  setuptools,
  six,
  tqdm,
  winacl,
  winsspi,
}:

buildPythonPackage rec {
  pname = "aiosmb";
  version = "0.4.14";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-So6u+sX7EOEIjrYejfWK/z/mH9bxHOcu/YpjF1VfAsM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asyauth
    asysocks
    colorama
    cryptography
    minikerberos
    prompt-toolkit
    pycryptodomex
    six
    tqdm
    winacl
    winsspi
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "aiosmb" ];

  meta = {
    description = "Python SMB library";
    homepage = "https://github.com/skelsec/aiosmb";
    changelog = "https://github.com/skelsec/aiosmb/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
