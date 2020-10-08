{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ijson";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "815e9ce9d2de7ddd58ba01834d8f55790b7daddbac6c844cba0fc459b7d5005a";
  };

  doCheck = false; # something about yajl

  meta = with stdenv.lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/ICRAR/ijson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvl ];
  };
}
