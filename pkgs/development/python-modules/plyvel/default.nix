{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "plyvel";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1icsycqqjj8048a0drj3j75a71yiv2cmijh4w3jf9zxahh3k2c9p";
  };

  buildInputs = [ pkgs.leveldb ] ++ stdenv.lib.optional isPy3k pytest;

  # no tests for python2
  doCheck = isPy3k;

  meta = with stdenv.lib; {
    description = "Fast and feature-rich Python interface to LevelDB";
    platforms = platforms.unix;
    homepage = https://github.com/wbolster/plyvel;
    license = licenses.bsd3;
  };
}
