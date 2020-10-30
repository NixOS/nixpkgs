{ lib, buildPythonPackage, fetchPypi, pythonOlder
, decorator, requests, simplejson, pillow, typing
, nose, mock, pytest, freezegun }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.39.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0ef69a27aad0e4412c1ac3e6894fa1b5741db735515c34dfe1606d8cf30e4e5";
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
