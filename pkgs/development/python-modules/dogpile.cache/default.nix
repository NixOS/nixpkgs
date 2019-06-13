{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, Mako, decorator
}:

buildPythonPackage rec {
  pname = "dogpile.cache";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "691b7f199561c4bd6e7e96f164a43cc3781b0c87bea29b7d59d859f873fd4a31";
  };

  # Disable concurrency tests that often fail,
  # probably some kind of timing issue.
  postPatch = ''
    rm tests/test_lock.py
    # Failing tests. https://bitbucket.org/zzzeek/dogpile.cache/issues/116
    rm tests/cache/test_memcached_backend.py
  '';

  checkInputs = [ pytest pytestcov mock Mako ];

  propagatedBuildInputs = [ decorator ];

  meta = with stdenv.lib; {
    description = "A caching front-end based on the Dogpile lock";
    homepage = https://bitbucket.org/zzzeek/dogpile.cache;
    license = licenses.bsd3;
  };
}
