{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "pyotp";
  version = "2.6.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d28ddfd40e0c1b6a6b9da961c7d47a10261fb58f378cb00f05ce88b26df9c432";
  };

  pythonImportsCheck = [ "pyotp" ];

  meta = with lib; {
    description = "Python One Time Password Library";
    homepage = "https://github.com/pyauth/pyotp";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
