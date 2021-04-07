{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, pytestcov
, mock
, Mako
, decorator
, stevedore
}:

buildPythonPackage rec {
  pname = "dogpile.cache";
  version = "1.1.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2134464672a3deb7ef1366a8691726686d8c62540e4208f1a40c9aaa1a0b6a45";
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

  propagatedBuildInputs = [ decorator stevedore ];

  meta = with lib; {
    description = "A caching front-end based on the Dogpile lock";
    homepage = "https://bitbucket.org/zzzeek/dogpile.cache";
    license = licenses.bsd3;
  };
}
