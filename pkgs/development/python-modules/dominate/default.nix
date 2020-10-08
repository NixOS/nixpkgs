{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "dominate";
  version = "2.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "456facce7a7ccfd9363948109cf1e978d48c58e46a46b01c71b4c0adc73b1928";
  };

  doCheck = !isPy3k;

  meta = with lib; {
    homepage = "https://github.com/Knio/dominate/";
    description = "Dominate is a Python library for creating and manipulating HTML documents using an elegant DOM API";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
