{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ijson";
  version = "2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08ppzz4my7dbs5bsdv3r1yn8bx8ijqmk5hjfdblrzrxhj184v4bs";
  };

  doCheck = false; # something about yajl

  meta = with stdenv.lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/isagalaev/ijson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvl ];
  };
}
