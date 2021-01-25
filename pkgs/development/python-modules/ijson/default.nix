{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ijson";
  version = "3.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d29977f7235b5bf83c372825c6abd8640ba0e3a8e031d3ffc3b63deaf6ae1487";
  };

  doCheck = false; # something about yajl

  meta = with lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/ICRAR/ijson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvl ];
  };
}
