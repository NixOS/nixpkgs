{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "dominate";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s9s9j9xmhkzw7apqx170fyvc0f800fd4a5jfn8xvj9k6vryd32b";
  };

  doCheck = !isPy3k;

  meta = with lib; {
    homepage = https://github.com/Knio/dominate/;
    description = "Dominate is a Python library for creating and manipulating HTML documents using an elegant DOM API";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
