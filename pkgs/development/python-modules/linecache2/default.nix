{ stdenv
, buildPythonPackage
, fetchPypi
, pbr
, isPy3k
}:

buildPythonPackage (rec {
  pname = "linecache2";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z79g3ds5wk2lvnqw0y2jpakjf32h95bd9zmnvp7dnqhf57gy9jb";
  };

  buildInputs = [ pbr ];
  # circular dependencies for tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A backport of linecache to older supported Pythons";
    homepage = "https://github.com/testing-cabal/linecache2";
    license = licenses.psfl;
  };
# TODO: move into main set, this was to avoid a rebuild
} // stdenv.lib.optionalAttrs (!isPy3k ) {
  # syntax error in tests. Tests are likely Python 3 only.
  dontUsePythonRecompileBytecode = !isPy3k;
})
