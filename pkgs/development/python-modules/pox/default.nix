{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pox";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "22e97ac6d2918c754e65a9581dbe02e9d00ae4a54ca48d05118f87c1ea92aa19";
  };

  meta = with stdenv.lib; {
    description = "Utilities for filesystem exploration and automated builds";
    license = licenses.bsd3;
    homepage = http://www.cacr.caltech.edu/~mmckerns/pox.htm;
  };

}
