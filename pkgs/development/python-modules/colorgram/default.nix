{ stdenv
, buildPythonPackage
, fetchPypi
, pillow
}:

buildPythonPackage rec {
  pname = "colorgram.py";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname;
    inherit version;
    sha256 = "e77766a5f9de7207bdef8f1c22a702cbf09630eae3bc46a450b9d9f12a7bfdbf";
  };

  propagatedBuildInputs = [ pillow ];

  meta = with stdenv.lib; {
    description = "A Python module for extracting colors from images. Get a palette of any picture!";
    homepage = https://github.com/obskyr/colorgram.py;
    license = licenses.mit;
  };

}

