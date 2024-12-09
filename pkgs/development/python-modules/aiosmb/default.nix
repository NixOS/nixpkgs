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
  pythonOlder,
  setuptools,
  six,
  tqdm,
  winacl,
  winsspi,
}:

buildPythonPackage rec {
  pname = "aiosmb";
  version = "0.4.11";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bWb1HtI1T3byBmE+rA1j83z9ntRL6figZZTUECRCc9c=";
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

  meta = with lib; {
    description = "Python SMB library";
    homepage = "https://github.com/skelsec/aiosmb";
    changelog = "https://github.com/skelsec/aiosmb/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
