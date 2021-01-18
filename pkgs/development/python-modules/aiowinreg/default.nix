{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiowinreg";
  version = "0.0.4";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "956278a90ef6958f9e2392891b2a305273f695b15b14489cd2097197d6cbe155";
  };

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
