{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, Mako
}:

buildPythonPackage rec {
  pname = "dogpile.cache";
  version = "0.6.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "631197e78b4471bb0e93d0a86264c45736bc9ae43b4205d581dcc34fbe9b5f31";
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
