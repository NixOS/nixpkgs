{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, Mako, decorator
}:

buildPythonPackage rec {
  pname = "dogpile.cache";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc9dde1ffa5de0179efbcdc73773ef0553921130ad01955422f2932be35c059e";
  };

  # Disable concurrency tests that often fail,
  # probably some kind of timing issue.
  postPatch = ''
    rm tests/test_lock.py
    # Failing tests. https://bitbucket.org/zzzeek/dogpile.cache/issues/116
    rm tests/cache/test_memcached_backend.py
  '';

  dontUseSetuptoolsCheck = true;
  checkPhase = ''
    pytest
  '';

  checkInputs = [ pytest pytestcov mock Mako ];

  propagatedBuildInputs = [ decorator ];

  meta = with stdenv.lib; {
    description = "A caching front-end based on the Dogpile lock";
    homepage = "https://bitbucket.org/zzzeek/dogpile.cache";
    license = licenses.bsd3;
  };
}
