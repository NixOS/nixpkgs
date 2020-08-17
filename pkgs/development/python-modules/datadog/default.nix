{ lib, buildPythonPackage, fetchPypi, pythonOlder
, decorator, requests, simplejson, pillow, typing
, nose, mock, pytest, freezegun }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.38.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "401cd1dcf2d5de05786016a1c790bff28d1428d12ae1dbe11485f9cb5502939b";
  };

  postPatch = ''
    find . -name '*.pyc' -exec rm {} \;
  '';

  propagatedBuildInputs = [ decorator requests simplejson pillow ]
    ++ lib.optionals (pythonOlder "3.5") [ typing ];

  checkInputs = [ nose mock pytest freezegun ];
  checkPhase = ''
    pytest tests/unit
  '';

  meta = with lib; {
    description = "The Datadog Python library";
    license = licenses.bsd3;
    homepage = "https://github.com/DataDog/datadogpy";
  };
}
