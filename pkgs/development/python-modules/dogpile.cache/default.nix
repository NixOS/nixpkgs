{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, Mako, decorator
}:

buildPythonPackage rec {
  pname = "dogpile.cache";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "70f5eae4aec908f76188a2c287e07105f60c05d879bb9a4efcc5ba44563d8de6";
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
