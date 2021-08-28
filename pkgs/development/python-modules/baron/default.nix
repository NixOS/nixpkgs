{ lib, fetchPypi, buildPythonPackage, rply, pytestCheckHook, isPy3k }:

buildPythonPackage rec {
  pname = "baron";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fib74nkqnl1i2zzlhbbfpw3whwc4951p9x61r2xrxhwp4r9yn5h";
  };

  propagatedBuildInputs = [ rply ];

  checkInputs = [ pytestCheckHook ];

  doCheck = isPy3k;

  meta = with lib; {
    homepage = "https://github.com/gristlabs/asttokens";
    description = "Abstraction on top of baron, a FST for python to make writing refactoring code a realistic task";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ marius851000 ];
  };
}
