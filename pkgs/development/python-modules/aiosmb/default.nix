{ lib
, asysocks
, buildPythonPackage
, colorama
, fetchPypi
, minikerberos
, prompt_toolkit
, pycryptodomex
, pythonOlder
, six
, tqdm
, winacl
, winsspi
}:

buildPythonPackage rec {
  pname = "aiosmb";
  version = "0.2.49";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XCaAaY7a6Gdddm9B0ET+rVzFra5W0GTI/HUMuvpyhzM=";
  };

  propagatedBuildInputs = [
    asysocks
    colorama
    minikerberos
    prompt_toolkit
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
