{ lib
, fetchPypi
, buildPythonPackage
, six
, cssselect
, lxml
, nose
}:

buildPythonPackage rec {
  pname = "leather";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+WS+wghvMVOmwW5wfyDLcY+BH1evEWB19MD0gFxgi5U=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [
    cssselect
    lxml
    nose
  ];

  checkPhase = ''
    runHook preCheck
    nosetests
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "http://leather.rtfd.io";
    description = "Python charting library";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ vrthra ];
  };
}
