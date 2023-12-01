{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, async-timeout
, typing-extensions
, hiredis
, isPyPy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioredis";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6qUar5k/LXH1S3BSfEQEN7plNAWIr+t4bNh8Vcic2Y4=";
  };

  patches = [
    # https://github.com/aio-libs-abandoned/aioredis-py/pull/1490
    (fetchpatch {
      name = "python-3.11-compatibility.patch";
      url = "https://github.com/aio-libs-abandoned/aioredis-py/commit/1b951502dc8f149fa66beafeea40c782f1c5c1d3.patch";
      hash = "sha256-EqkiYktxISg0Rv4ShXOksGvuUyljPxjJsfNOVaaax2o=";
      includes = [ "aioredis/exceptions.py" ];
    })
  ];

  propagatedBuildInputs = [
    async-timeout
    typing-extensions
  ] ++ lib.optional (!isPyPy) hiredis;

  # Wants to run redis-server, hardcoded FHS paths, too much trouble.
  doCheck = false;

  meta = with lib; {
    description = "Asyncio (PEP 3156) Redis client library";
    homepage = "https://github.com/aio-libs-abandoned/aioredis-py";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
