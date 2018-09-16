{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, Mako
}:

buildPythonPackage rec {
  pname = "dogpile.cache";
  version = "0.6.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fca7deb7c276b879b01c15c5d39b3c05701dc43b263ec3fef1e52cb851cf88ab";
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
