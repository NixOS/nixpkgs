{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
, monotonic
, backoff
, python-dateutil
}:

buildPythonPackage rec {
  pname = "analytics-python";
  version = "1.4.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "plFBq25H2zlvW8Vwix25P/mpmILYH+gIIor9Xrtt/l8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"backoff==1.10.0"' '"backoff>=1.10.0,<3"'
  '';

  propagatedBuildInputs = [
    monotonic
    requests
    backoff
    python-dateutil
  ];

  # Almost all tests run against a hosted API, and the few that are mocked are hard to cherry-pick
  doCheck = false;

  pythonImportsCheck = [
    "analytics"
    "analytics.client"
    "analytics.consumer"
    "analytics.request"
    "analytics.utils"
    "analytics.version"
  ];

  meta = with lib; {
    homepage = "https://segment.com/libraries/python";
    description = "Hassle-free way to integrate analytics into any python application";
    license = licenses.mit;
    maintainers = [ ];
  };
}
