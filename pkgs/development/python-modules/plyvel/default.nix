{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "plyvel";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xkgj58i66w4h6gwp6fn6xj5nkrad6kxz3byhy9q1j94jml1ns1x";
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
