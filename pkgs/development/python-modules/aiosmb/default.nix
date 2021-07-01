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
  version = "0.2.48";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5518987e3d41d213a4ffc4dd38362465b5d2cf99417014cb5402f8ee8c5abac";
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
