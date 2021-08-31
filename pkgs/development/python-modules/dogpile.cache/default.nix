{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, pytest-cov
, mock
, Mako
, decorator
, stevedore
}:

buildPythonPackage rec {
  pname = "dogpile.cache";
  version = "1.1.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f0bcf97c73bfec1a7bf14e5a248488cee00c2d494bf63f3789ea6d95a57c1cf";
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

  checkInputs = [ pytest pytest-cov mock Mako ];

  propagatedBuildInputs = [ decorator stevedore ];

  meta = with lib; {
    description = "A caching front-end based on the Dogpile lock";
    homepage = "https://bitbucket.org/zzzeek/dogpile.cache";
    license = licenses.bsd3;
  };
}
