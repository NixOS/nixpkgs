{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "pyotp";
  version = "2.4.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "038a3f70b34eaad3f72459e8b411662ef8dfcdd95f7d9203fa489e987a75584b";
  };

  pythonImportsCheck = [ "pyotp" ];

  meta = with lib; {
    description = "Python One Time Password Library";
    homepage = "https://github.com/pyotp/pyotp";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
