{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "pyotp";
  version = "2.4.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "01eceab573181188fe038d001e42777884a7f5367203080ef5bda0e30fe82d28";
  };

  pythonImportsCheck = [ "pyotp" ];

  meta = with lib; {
    description = "Python One Time Password Library";
    homepage = "https://github.com/pyotp/pyotp";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
