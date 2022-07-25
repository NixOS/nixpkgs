{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "dominate";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UgEBNgiS6/nQVT9n0341n/kkA9ih4zgUAwUDCIoF2kk=";
  };

  doCheck = !isPy3k;

  meta = with lib; {
    homepage = "https://github.com/Knio/dominate/";
    description = "Dominate is a Python library for creating and manipulating HTML documents using an elegant DOM API";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
