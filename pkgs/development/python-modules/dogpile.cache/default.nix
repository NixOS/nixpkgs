{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, Mako
}:

buildPythonPackage rec {
  pname = "dogpile.cache";
  version = "0.6.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2fbe5d95e6df3fcfff2b666c69f3c06a4a3f77296142ae2bca523a176f88fa0";
  };

  # Disable concurrency tests that often fail,
  # probably some kind of timing issue.
  postPatch = ''
    rm tests/test_lock.py
    # Failing tests. https://bitbucket.org/zzzeek/dogpile.cache/issues/116
    rm tests/cache/test_memcached_backend.py
  '';

  buildInputs = [ pytest pytestcov mock Mako ];

  meta = with stdenv.lib; {
    description = "A caching front-end based on the Dogpile lock";
    homepage = https://bitbucket.org/zzzeek/dogpile.cache;
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
