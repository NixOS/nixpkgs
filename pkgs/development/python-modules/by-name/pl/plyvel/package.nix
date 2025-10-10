{
  lib,
  buildPythonPackage,
  fetchPypi,
  pkgs,
  pytest,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "plyvel";
  version = "1.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PK9gCeT8JPv4cS0/XvPaflZJXCakiN8hYSGPw05GAZw=";
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
