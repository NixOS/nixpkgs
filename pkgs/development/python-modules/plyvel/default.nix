{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "plyvel";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14cbdyq1s8xmvha3lj942gw478cd6jyhkw8n0mhxpgbz8px9jkfn";
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
