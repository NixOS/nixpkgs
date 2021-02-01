{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "pyotp";
  version = "2.5.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a54d393aff3a244b566d78d597c9cb42e91b3b12f3169cec89d9dfff1c9c5bc";
  };

  pythonImportsCheck = [ "pyotp" ];

  meta = with lib; {
    description = "Python One Time Password Library";
    homepage = "https://github.com/pyotp/pyotp";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
