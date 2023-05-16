{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  format = "setuptools";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
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

=======
    sha256 = "eaa51aaf993f2d71f54b70527c440437ba65340588afeb786cd87c55c89cd98e";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    async-timeout
    typing-extensions
  ] ++ lib.optional (!isPyPy) hiredis;

  # Wants to run redis-server, hardcoded FHS paths, too much trouble.
  doCheck = false;

  meta = with lib; {
    description = "Asyncio (PEP 3156) Redis client library";
<<<<<<< HEAD
    homepage = "https://github.com/aio-libs-abandoned/aioredis-py";
=======
    homepage = "https://github.com/aio-libs/aioredis";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
