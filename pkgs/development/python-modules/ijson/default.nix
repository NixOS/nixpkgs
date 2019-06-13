{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ijson";
  version = "2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x7l9k2dvxzd5mjgiq15nl9b0sxcqy1cqaz744bjwkz4z5mrypzg";
  };

  doCheck = false; # something about yajl

  meta = with stdenv.lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/isagalaev/ijson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvl ];
  };
}
