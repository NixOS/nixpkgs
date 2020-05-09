{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ijson";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1774vhabygdiq1avkir5nmavcxrr5npx5nnr6anxgh9zpdsf1rm1";
  };

  doCheck = false; # something about yajl

  meta = with stdenv.lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/ICRAR/ijson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvl ];
  };
}
