{ lib
, arc4
, asn1crypto
, asn1tools
, asysocks
, buildPythonPackage
, colorama
, fetchPypi
, minikerberos
, pillow
, pyperclip
, pythonOlder
, tqdm
, unicrypto
, winsspi
}:

buildPythonPackage rec {
  pname = "aardwolf";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+rlmpXatsVep2jgDyQfr4LxIcy8vBAsPGmQZK4Dr4WQ=";
  };

  propagatedBuildInputs = [
    arc4
    asn1crypto
    asn1tools
    asysocks
    colorama
    minikerberos
    pillow
    pyperclip
    tqdm
    unicrypto
    winsspi
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "aardwolf"
  ];

  meta = with lib; {
    description = "Asynchronous RDP protocol implementation";
    homepage = "https://github.com/skelsec/aardwolf";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
