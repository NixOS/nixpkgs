{ lib
, buildPythonPackage
, fetchPypi
, pkgs
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "plyvel";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zZGOCzFpCrzT0gKodCyvlRqy/hVz3nr3HDhFaEf5ICs=";
  };

  buildInputs = [ pkgs.leveldb ] ++ lib.optional isPy3k pytest;

  # no tests for python2
  doCheck = isPy3k;

  meta = with lib; {
    description = "Fast and feature-rich Python interface to LevelDB";
    platforms = platforms.unix;
    homepage = "https://github.com/wbolster/plyvel";
    license = licenses.bsd3;
  };
}
