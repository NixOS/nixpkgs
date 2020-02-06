{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ijson";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19ec46a2f7991004e5202ecee56c569616b8a7f95686ad7fd0a9ec81cac00269";
  };

  doCheck = false; # something about yajl

  meta = with stdenv.lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/isagalaev/ijson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvl ];
  };
}
