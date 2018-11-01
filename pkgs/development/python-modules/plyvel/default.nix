{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "plyvel";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1scq75qyks9vmjd19bx57f2y60mkdr44ajvb12p3cjg439l96zaq";
  };

  buildInputs = [ pkgs.leveldb ] ++ stdenv.lib.optional isPy3k pytest;

  # no tests for python2
  doCheck = isPy3k;

  meta = with stdenv.lib; {
    description = "Fast and feature-rich Python interface to LevelDB";
    homepage = https://github.com/wbolster/plyvel;
    license = licenses.bsd3;
  };

}
