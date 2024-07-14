{
  lib,
  buildPythonPackage,
  fetchPypi,
  pillow,
  isPy27,
}:

buildPythonPackage rec {
  pname = "modestmaps";
  version = "1.4.7";
  disabled = !isPy27;

  src = fetchPypi {
    pname = "ModestMaps";
    inherit version;
    hash = "sha256-aYRCoXDwKSP46lXxhSa1bBcXgWLkQwT4lqil/WWrRFc=";
  };

  propagatedBuildInputs = [ pillow ];

  meta = with lib; {
    description = "Library for building interactive maps";
    homepage = "http://modestmaps.com";
    license = licenses.bsd3;
  };
}
