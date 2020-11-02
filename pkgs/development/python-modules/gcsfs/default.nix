{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, fsspec
, google_auth
, google-auth-oauthlib
, requests
, decorator
, aiohttp
}:

buildPythonPackage rec {
  pname = "gcsfs";
  version = "0.7.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "03658dfbf1a734d987aab3631e0a342b3d7e24a24998b4d8d2491fdd21053720";
  };

  # tests are accessing the network
  doCheck = false;
  pythonImportsCheck = [ "gcsfs" ];

  propagatedBuildInputs = [
    fsspec
    google_auth
    google-auth-oauthlib
    requests
    decorator
    aiohttp
  ];

  meta = with lib; {
    description = "Pythonic file-system for Google Cloud Storage";
    homepage = "https://github.com/dask/gcsfs";
    license = licenses.bsd3;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.all;
  };
}
