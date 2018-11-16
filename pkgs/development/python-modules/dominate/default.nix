{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "dominate";
  version = "2.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8dfcca2bde3937a2d03db6e55efcb0c0dea0d4ab0923dc983d794b19e9247328";
  };

  doCheck = !isPy3k;

  meta = with lib; {
    homepage = https://github.com/Knio/dominate/;
    description = "Dominate is a Python library for creating and manipulating HTML documents using an elegant DOM API";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
