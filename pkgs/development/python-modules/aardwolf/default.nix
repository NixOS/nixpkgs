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
  version = "0.0.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-plz1D+Lr5rV8iJo7IUmuXfjxLvVxX9lgyxyYXUlPH0k=";
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
