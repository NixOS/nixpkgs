{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, mock
, mako
, decorator
, stevedore
}:

buildPythonPackage rec {
  pname = "dogpile-cache";
  version = "1.2.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "dogpile.cache";
    inherit version;
    hash = "sha256-R1VMhgzrSE3Vrvn/H4j+yz1K72u5IRlFD1vLqgJrv7E=";
  };

  preCheck = ''
    # Disable concurrency tests that often fail,
    # probably some kind of timing issue.
    rm tests/test_lock.py
    # Failing tests. https://bitbucket.org/zzzeek/dogpile.cache/issues/116
    rm tests/cache/test_memcached_backend.py
  '';

  dontUseSetuptoolsCheck = true;

  nativeCheckInputs = [ pytestCheckHook mock mako ];

  propagatedBuildInputs = [ decorator stevedore ];

  meta = with lib; {
    description = "A caching front-end based on the Dogpile lock";
    homepage = "https://bitbucket.org/zzzeek/dogpile.cache";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
