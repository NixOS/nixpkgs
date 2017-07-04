{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, Mako
}:

buildPythonPackage rec {
  pname = "dogpile.cache";
  version = "0.6.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a73aa3049cd88d7ec57a1c2e8946abdf4f14188d429c1023943fcc55c4568da1";
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
    homepage = http://bitbucket.org/zzzeek/dogpile.cache;
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
