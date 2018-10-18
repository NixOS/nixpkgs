{ stdenv
, buildPythonPackage
, fetchPypi
, pillow
, isPy27
}:

buildPythonPackage rec {
  pname = "ModestMaps";
  version = "1.4.6";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vyi1m9q4pc34i6rq5agb4x3qicx5sjlbxwmxfk70k2l5mnbjca3";
  };

  propagatedBuildInputs = [ pillow ];

  meta = with stdenv.lib; {
    description = "A library for building interactive maps";
    homepage = http://modestmaps.com;
    license = stdenv.lib.licenses.bsd3;
  };

}
