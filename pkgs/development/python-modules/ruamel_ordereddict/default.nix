{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
}:

buildPythonPackage rec {
  pname = "ruamel.ordereddict";
  version = "0.4.15";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d7d9cf8b11e7662deb460260cf062980cd84b87a1d0457132060ab9d44e0a5f4";
  };

  meta = with lib; {
    description = "A version of dict that keeps keys in insertion resp. sorted order";
    homepage = "https://sourceforge.net/projects/ruamel-ordereddict/";
    license = licenses.mit;
  };

}
