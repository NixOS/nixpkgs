{ lib, buildPythonPackage, fetchPypi
, decorator, requests, simplejson
, nose, mock }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.26.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbaa6b4b2b88fd552605e6730f60d5437017bb76d6b701432eaafbc983735b79";
  };

  postPatch = ''
    find . -name '*.pyc' -exec rm {} \;
  '';

  propagatedBuildInputs = [ decorator requests simplejson ];

  checkInputs = [ nose mock ];

  meta = with lib; {
    description = "The Datadog Python library";
    license = licenses.bsd3;
    homepage = https://github.com/DataDog/datadogpy;
  };
}
