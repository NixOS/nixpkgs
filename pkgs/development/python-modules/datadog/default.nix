{ lib, buildPythonPackage, fetchPypi
, decorator, requests, simplejson, pillow
, nose, mock, pytest, freezegun }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.33.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bce73f33a4496b004402baa502251150e3b48a48f610ff89d4cd110b366ee0ab";
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
    homepage = https://github.com/DataDog/datadogpy;
  };
}
