{ lib
, buildPythonPackage
, boto3
, cachecontrol
, fetchFromGitHub
, iso3166
, python-dateutil
, requests
, responses
, polyline
, pytestCheckHook
, uritemplate
}:

buildPythonPackage rec {
  pname = "mapbox";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "mapbox-sdk-py";
    rev = "0.18.0";
    sha256 = "123wsa4j11ps5pkjgylbmw4gnzh2vi22swgmvy50w26glkszh075";
  };

  propagatedBuildInputs = [ boto3 cachecontrol iso3166 python-dateutil requests polyline uritemplate ];
  nativeCheckInputs = [ pytestCheckHook responses ];

  meta = with lib; {
    homepage = "https://github.com/mapbox/mapbox-sdk-py";
    license = licenses.mit;
    description = "Mapbox SDK for Python";
    longDescription = "Low-level client API for Mapbox web services.";
    maintainers = with maintainers; [ ersin ];
    # ImportError: cannot import name 'Mapping' from 'collections'
    # and archived upstreamed
    broken = true;
  };
}
