{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pydns";
  version = "2.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qnv7i9824nb5h9psj0rwzjyprwgfiwh5s5raa9avbqazy5hv5pi";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python DNS library";
    homepage = http://pydns.sourceforge.net/;
    license = licenses.psfl;
  };

}
