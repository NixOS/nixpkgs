{ lib
, buildPythonPackage
, fetchPypi
, async-timeout
, pysnmplib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "atenpdu";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E/cRjbispHiS38BdIvOKD4jOFrDmpx8L4eAlMV8Re70=";
  };

  propagatedBuildInputs = [
    async-timeout
    pysnmplib
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [
    "atenpdu"
  ];

  meta = with lib; {
    description = "Python interface to control ATEN PE PDUs";
    homepage = "https://github.com/mtdcr/pductl";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
