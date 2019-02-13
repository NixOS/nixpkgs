{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pox";
  version = "0.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c8955d9beed4f9fd509587d17820efe6bc9f9b4a1abe581642aeed9a41784ea";
  };

  meta = with stdenv.lib; {
    description = "Utilities for filesystem exploration and automated builds";
    license = licenses.bsd3;
    homepage = http://www.cacr.caltech.edu/~mmckerns/pox.htm;
  };

}
