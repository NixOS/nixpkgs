{ lib
, asysocks
, buildPythonPackage
, colorama
, fetchPypi
, minikerberos
, prompt_toolkit
, pythonOlder
, six
, tqdm
, winacl
, winsspi
}:

buildPythonPackage rec {
  pname = "aiosmb";
  version = "0.2.44";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xNdrOO0BqV4sD6U39G2RXihDBBf516x8RLiqNLnZyWk=";
  };

  propagatedBuildInputs = [
    asysocks
    colorama
    minikerberos
    prompt_toolkit
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
