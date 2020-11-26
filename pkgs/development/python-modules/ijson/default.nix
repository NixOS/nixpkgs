{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ijson";
  version = "3.1.2.post0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04fd8ebb8edb39db81f49b75b101d1e2a4d0728460e253fd9c98e3e17f9caa16";
  };

  doCheck = false; # something about yajl

  meta = with stdenv.lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/ICRAR/ijson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvl ];
  };
}
