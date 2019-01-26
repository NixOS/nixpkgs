{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "nine";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3064fbeb512e756a415606a1399f49c22de867d5ac7e2b6c91c35e757d3af42d";
  };

  meta = with stdenv.lib; {
    description = "Let's write Python 3 right now!";
    homepage = "https://github.com/nandoflorestan/nine";
    license = licenses.free;
  };

}
