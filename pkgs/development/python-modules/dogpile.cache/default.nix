{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, Mako, decorator
}:

buildPythonPackage rec {
  pname = "dogpile.cache";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sr1fn6b4k5bh0cscd9yi8csqxvj4ngzildav58x5p694mc86j5k";
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
    homepage = https://bitbucket.org/zzzeek/dogpile.cache;
    license = licenses.bsd3;
  };
}
