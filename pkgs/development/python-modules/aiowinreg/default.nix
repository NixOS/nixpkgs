{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, winacl
, prompt-toolkit
}:

buildPythonPackage rec {
  pname = "aiowinreg";
  version = "0.0.6";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h0r9xrz1n8y75f2p21f7phqrlpsymyiipmgzr0lj591irzjmjjy";
  };

  propagatedBuildInputs = [
    prompt-toolkit
    winacl
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "aiowinreg" ];

  meta = with lib; {
    description = "Python module to parse the registry hive";
    homepage = "https://github.com/skelsec/aiowinreg";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
