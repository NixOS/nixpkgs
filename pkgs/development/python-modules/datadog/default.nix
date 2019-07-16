{ lib, buildPythonPackage, fetchPypi
, decorator, requests, simplejson
, nose, mock }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.29.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p47hy1p2hf233blalyz0yr6nf13iwk9ndkqdk428dmf8b8m2plr";
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
