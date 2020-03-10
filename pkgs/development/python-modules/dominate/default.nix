{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "dominate";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y4xzch6kwzddwz6pmk8cd09r3dpkxm1bh4q1byhm37a0lb4h1cv";
  };

  doCheck = !isPy3k;

  meta = with lib; {
    homepage = "https://github.com/Knio/dominate/";
    description = "Dominate is a Python library for creating and manipulating HTML documents using an elegant DOM API";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
