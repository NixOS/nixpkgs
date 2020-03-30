{ lib, buildPythonPackage, fetchPypi
, decorator, requests, simplejson, pillow
, nose, mock, pytest, freezegun }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.34.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1msi3wm0khmzh0ad7lwd5gigmqrxj25hd4w0qrsarihmd4ywrn1v";
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
