{ lib
, buildPythonPackage
, fetchPypi
, pkgs
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "plyvel";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7a09033a0fd33ca47094e8bbe01714abfcf644f4b7a337d3970e91a2599e2c4";
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
