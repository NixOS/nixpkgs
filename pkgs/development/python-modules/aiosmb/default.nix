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
    sha256 = "1b5bqpl8wbs0nm6025wlz4n5sns6ca1x6kgw9wx227flwf3qjlgm";
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
