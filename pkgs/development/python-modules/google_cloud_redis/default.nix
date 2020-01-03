{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-redis";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e24a5eeb126a3e8fcf990806c7a853a27bb9b830c2f03fda42a499894b7614c6";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ enum34 google_api_core ];

  # requires old version of google-api-core (override)
  preBuild = ''
    sed -i "s/'google-api-core\[grpc\] >= 0.1.0, < 0.2.0dev'/'google-api-core'/g" setup.py
    sed -i "s/google-api-core\[grpc\]<0.2.0dev,>=0.1.0/google-api-core/g" google_cloud_redis.egg-info/requires.txt
  '';

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Memorystore for Redis API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
