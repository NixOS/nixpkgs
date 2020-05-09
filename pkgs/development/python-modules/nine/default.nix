{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "nine";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1givimwypxkvsgckhr4laz4k6h5gsb0mghm9bk93f5il4rinpag8";
  };

  meta = with stdenv.lib; {
    description = "Let's write Python 3 right now!";
    homepage = "https://github.com/nandoflorestan/nine";
    license = licenses.free;
  };

}
