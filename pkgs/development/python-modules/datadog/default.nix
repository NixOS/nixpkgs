{ lib, buildPythonPackage, fetchPypi
, decorator, requests, simplejson, pillow
, nose, mock, pytest, freezegun }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.35.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qpy6mg9gfjxvjms0aaglzayhmdds4agv0lh05g2mkfw620nm8zl";
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
