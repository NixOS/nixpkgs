{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "dominate";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76ec2cde23700a6fc4fee098168b9dee43b99c2f1dd0ca6a711f683e8eb7e1e4";
  };

  doCheck = !isPy3k;

  meta = with lib; {
    homepage = "https://github.com/Knio/dominate/";
    description = "Dominate is a Python library for creating and manipulating HTML documents using an elegant DOM API";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
