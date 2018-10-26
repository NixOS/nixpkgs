{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
}:

buildPythonPackage rec {
  pname = "ruamel.ordereddict";
  version = "0.4.9";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xmkl8v9l9inm2pyxgc1fm5005yxm7fkd5gv74q7lj1iy5qc8n3h";
  };

  meta = with stdenv.lib; {
    description = "A version of dict that keeps keys in insertion resp. sorted order";
    homepage = https://bitbucket.org/ruamel/ordereddict;
    license = licenses.mit;
  };

}
