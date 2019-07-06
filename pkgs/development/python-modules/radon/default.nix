{ lib, buildPythonPackage, fetchPypi, flake8-polyfill, colorama, mando, future }:

buildPythonPackage rec {
  pname = "radon";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g9bi0qchjd6illda65k59ipf00s2hxvc9bl0sdsirxsx263087f";
  };

  propagatedBuildInputs = [ flake8-polyfill colorama mando future ];

  doCheck = false;

  meta = with lib; {
    description = "Code Metrics in Python";
    homepage = https://radon.readthedocs.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ lnl7 ];
  };
}

