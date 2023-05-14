{ lib
, buildPythonPackage
, fetchPypi
, six
, flake8
, nose
}:

buildPythonPackage rec {
  pname = "polyline";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FJK4/K3CFD+K7cZz08bZXfRRMfHGLrjVHIGDsk53FIY=";
  };

  propagatedBuildInputs = [ six ];
  nativeCheckInputs = [ flake8 nose ];
  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = "https://github.com/hicsail/polyline";
    license = licenses.mit;
    description = "Python implementation of Google's Encoded Polyline Algorithm Format.";
    longDescription = "polyline is a Python implementation of Google's Encoded Polyline Algorithm Format (http://goo.gl/PvXf8Y). It is essentially a port of https://github.com/mapbox/polyline built with Python 2 and 3 support in mind.";
    maintainers = with maintainers; [ ersin ];
  };
}
