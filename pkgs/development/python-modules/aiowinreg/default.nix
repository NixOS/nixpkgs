{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, winacl
, prompt-toolkit
}:

buildPythonPackage rec {
  pname = "aiowinreg";
  version = "0.0.7";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p88q2b6slm1sw3234r40s9jd03fqlkcx8y3iwg6ihf0z4ww14d1";
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
