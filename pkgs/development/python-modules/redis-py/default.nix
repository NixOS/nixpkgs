{ stdenv
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {

  pname = "redis-py";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ba8612bbfd966dea8c62322543fed0095da2834dbd5a7c124afbc617a156aa7";
  };

  # Tests require a running redis
  doCheck = false;

  meta = with stdenv.lib; {
    # Note: this is ALMOST identical to the existing 'pythonPackages.redis'
    #       package; except that the module name was modified to accomodate
    #       other modules which use this alternative name. I believe that the
    #       rationale on the part of other developers was that 'redis' was an
    #       innapropriate name because it does not properly distinguish itself
    #       from the actual 'redis' executable.
    description = "Python client for Redis key-value store";
    homepage = "https://pypi.python.org/pypi/redis/";
    license = licenses.mit;
  };

}
