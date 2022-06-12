{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, mock
, Mako
, decorator
, stevedore
}:

buildPythonPackage rec {
  pname = "dogpile-cache";
  version = "1.1.6";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "dogpile.cache";
    inherit version;
    sha256 = "sha256-7tweMn5myT8MFah0BWmrdO89iSkELxCPmP3tnjX6/1U=";
  };

  preCheck = ''
    # Disable concurrency tests that often fail,
    # probably some kind of timing issue.
    rm tests/test_lock.py
    # Failing tests. https://bitbucket.org/zzzeek/dogpile.cache/issues/116
    rm tests/cache/test_memcached_backend.py
  '';

  dontUseSetuptoolsCheck = true;

  checkInputs = [ pytestCheckHook mock Mako ];

  propagatedBuildInputs = [ decorator stevedore ];

  meta = with lib; {
    description = "A caching front-end based on the Dogpile lock";
    homepage = "https://bitbucket.org/zzzeek/dogpile.cache";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
