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
    sha256 = "698442a170f02923f8ea55f18526b56c17178162e44304f896a8a5fd65ab4457";
  };

  propagatedBuildInputs = [ pillow ];

  meta = with lib; {
    description = "A library for building interactive maps";
    homepage = "http://modestmaps.com";
    license = licenses.bsd3;
  };
}
