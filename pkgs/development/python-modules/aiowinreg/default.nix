{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiowinreg";
  version = "0.0.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gxhx9m45yyr1rmgs7f1jchkgxk2zipk9g3s5ix90d267in8hsn9";
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
