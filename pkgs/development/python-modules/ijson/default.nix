{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ijson";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l034zq23315icym2n0zppa5lwpdll3mvavmyjbiryxb4c5wdsvm";
  };

  doCheck = false; # something about yajl

  meta = with stdenv.lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/ICRAR/ijson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvl ];
  };
}
