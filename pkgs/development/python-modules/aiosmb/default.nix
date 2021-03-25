{ lib
, asysocks
, buildPythonPackage
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
  version = "0.2.37";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0daf1fk7406vpywc0yxv0wzf4nw986js9lc2agfyfxz0q7s29lf0";
  };

  propagatedBuildInputs = [
    minikerberos
    winsspi
    six
    asysocks
    tqdm
    prompt_toolkit
    winacl
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
