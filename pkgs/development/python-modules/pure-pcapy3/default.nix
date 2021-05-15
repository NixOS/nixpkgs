{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pure-pcapy3";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14panfklap6wwi9avw46gvd7wg9mkv9xbixvbvmi1m2adpqlb7mr";
  };

  meta = with lib; {
    description = "Pure Python reimplementation of pcapy. This package is API compatible and a drop-in replacement.";
    homepage = "https://bitbucket.org/viraptor/pure-pcapy";
    license = licenses.bsd2;
    maintainers = with maintainers; [ etu ];
  };
}
