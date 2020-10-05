{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ijson";
  version = "3.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "401bdca19bcc7f89780e37d7b70671d40666999dac3e4b2c42a7cddd8b0891c7";
  };

  doCheck = false; # something about yajl

  meta = with stdenv.lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/ICRAR/ijson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvl ];
  };
}
