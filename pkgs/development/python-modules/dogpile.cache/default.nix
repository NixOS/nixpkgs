{ stdenv, buildPythonPackage, fetchPypi
, dogpile_core, pytest, pytestcov, mock, Mako
}:

buildPythonPackage rec {
  pname = "dogpile.cache";
  version = "0.6.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9747f5e31f8dea1b80d6204358885f943f69e53574d88005438ca3651c44553";
  };

  # Disable concurrency tests that often fail,
  # probably some kind of timing issue.
  prePatch = ''
    rm tests/test_lock.py
  '';

  propagatedBuildInputs = [ dogpile_core ];
  buildInputs = [ pytest pytestcov mock Mako ];

  meta = with stdenv.lib; {
    description = "A caching front-end based on the Dogpile lock";
    homepage = http://bitbucket.org/zzzeek/dogpile.cache;
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
