{ lib, buildPythonPackage, fetchPypi
, decorator, requests, simplejson
, nose, mock
, pillow
 }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.30.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07c053e39c6509023d69bc2f3b8e3d5d101b4e75baf2da2b9fc707391c3e773d";
  };

  postPatch = ''
    find . -name '*.pyc' -exec rm {} \;
  '';

  propagatedBuildInputs = [ decorator requests simplejson ];

  checkInputs = [ nose mock pillow ];

  meta = with lib; {
    description = "The Datadog Python library";
    license = licenses.bsd3;
    homepage = https://github.com/DataDog/datadogpy;
  };
}
