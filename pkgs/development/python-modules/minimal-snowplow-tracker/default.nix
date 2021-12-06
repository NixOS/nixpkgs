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
    sha256 = "276ced7e9e3cb22e5d7c14748384a5cf5d9002257c0ed50c0e075b68011bb6d0";
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
