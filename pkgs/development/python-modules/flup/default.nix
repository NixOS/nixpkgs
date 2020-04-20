{ stdenv
, buildPythonPackage
, isPy3k
, fetchPypi
}:

buildPythonPackage rec {
  pname = "flup";
  version = "1.0.3";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5eb09f26eb0751f8380d8ac43d1dfb20e1d42eca0fa45ea9289fa532a79cd159";
  };

  meta = with stdenv.lib; {
    homepage = "https://www.saddi.com/software/flup/";
    description = "FastCGI Python module set";
    license = licenses.bsd0;
  };

}
