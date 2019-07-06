{ lib, buildPythonPackage, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "mando";
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q6rl085q1hw1wic52pqfndr0x3nirbxnhqj9akdm5zhq2fv3zkr";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Create Python CLI apps with little to no effort at all!";
    homepage = https://mando.readthedocs.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ lnl7 ];
  };
}
