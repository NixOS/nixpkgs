{ lib, buildPythonPackage, fetchPypi
, decorator, requests, simplejson, pillow
, nose, mock, pytest, freezegun }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.36.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kkbsrzxc2a6k319lh98qkinn99dzcqz8h4fm25q17dlgmc9gq9z";
  };

  postPatch = ''
    find . -name '*.pyc' -exec rm {} \;
  '';

  propagatedBuildInputs = [ decorator requests simplejson pillow ];

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
