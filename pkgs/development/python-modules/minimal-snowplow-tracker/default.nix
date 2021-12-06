{ lib
, fetchPypi
, buildPythonPackage
, requests
, pycontracts
, six
, autopep8
}:

buildPythonPackage rec {
  pname = "minimal-snowplow-tracker";
  version = "0.0.2";

  src = fetchPypi {
    inherit pname version;
    hash= "sha256-rKv3Vy2w5/XL9pg9SV7vVAgfcb45IzDrOq25zLOdqqQ=";
  };

  buildInputs = [ autopep8 ];

  propagatedBuildInputs = [
    requests
    pycontracts
    six
  ];

  meta = with lib; {
    description = "Snowplow event tracker for Python";
    homepage = "http://snowplowanalytics.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
