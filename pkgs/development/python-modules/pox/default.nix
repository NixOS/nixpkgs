{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pox";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b53fbdf02596240483dc2cb94f94cc21252ad1b1858c7b1c151afeec9022cc8";
  };

  meta = with stdenv.lib; {
    description = "Utilities for filesystem exploration and automated builds";
    license = licenses.bsd3;
    homepage = http://www.cacr.caltech.edu/~mmckerns/pox.htm;
  };

}
