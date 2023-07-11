{ lib
, asyauth
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
  version = "0.4.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y0Z76YP1cWcfMKZOn2L6z4B+hAdibxJOYBzT3WV6FcY=";
  };

  propagatedBuildInputs = [
    asyauth
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
    changelog = "https://github.com/skelsec/aiosmb/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
