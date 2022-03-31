{ lib
, asysocks
, buildPythonPackage
, colorama
, fetchPypi
, minikerberos
, prompt-toolkit
, pycryptodomex
, pythonOlder
, six
, tqdm
, winacl
, winsspi
}:

buildPythonPackage rec {
  pname = "aiosmb";
  version = "0.3.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CvqQEJPwrZHQuEId7GbIC9LpyyN6jaQFmEQTpddHU5g=";
  };

  propagatedBuildInputs = [
    asysocks
    colorama
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

  pythonImportsCheck = [
    "aiosmb"
  ];

  meta = with lib; {
    description = "Python SMB library";
    homepage = "https://github.com/skelsec/aiosmb";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
