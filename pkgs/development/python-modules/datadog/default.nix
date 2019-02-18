{ lib, buildPythonPackage, fetchPypi
, decorator, requests, simplejson
, nose, mock }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e71f9024fb0b968bd704178c7e48fa41ce728281cc6913994db5e065596cddf1";
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
