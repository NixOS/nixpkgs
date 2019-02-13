{ stdenv
, buildPythonPackage
, fetchPypi
, pillow
, isPy27
}:

buildPythonPackage rec {
  pname = "ModestMaps";
  version = "1.4.7";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "698442a170f02923f8ea55f18526b56c17178162e44304f896a8a5fd65ab4457";
  };

  propagatedBuildInputs = [ pillow ];

  meta = with stdenv.lib; {
    description = "A library for building interactive maps";
    homepage = http://modestmaps.com;
    license = stdenv.lib.licenses.bsd3;
  };

}
