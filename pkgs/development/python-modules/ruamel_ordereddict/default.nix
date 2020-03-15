{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
}:

buildPythonPackage rec {
  pname = "ruamel.ordereddict";
  version = "0.4.14";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "281051d26eb2b18ef3d920e1e260716a52bd058a6b1a2f324102fc6a15cb8d4a";
  };

  meta = with stdenv.lib; {
    description = "A version of dict that keeps keys in insertion resp. sorted order";
    homepage = "https://sourceforge.net/projects/ruamel-ordereddict/";
    license = licenses.mit;
  };

}
