{ lib, buildPythonPackage, fetchPypi, pythonOlder
, decorator, requests, simplejson, pillow, typing
, nose, mock, pytest, freezegun }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.40.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4bbd66a02bbcf9cd03ba05194d605a64c9efb7aed90d5e69c6ec42655c3c01a4";
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
