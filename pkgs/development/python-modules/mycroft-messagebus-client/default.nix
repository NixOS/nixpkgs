{ lib
, buildPythonPackage
, fetchPypi

# runtime
, pyee
, websocket-client

# tests
, pytestCheckHook
}:

let
  pname = "mycroft-messagebus-client";
  version = "0.9.6";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-u7jpSzuNvO5faAuUv4MOAM37oPVLmLu5ODoKLlZoZUY=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "pyee==8.1.0" "pyee>=8.1.0"
  '';

  propagatedBuildInputs = [
    pyee
    websocket-client
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mycroft_bus_client"
  ];

  meta = with lib; {
    description = "Python module for connecting to the mycroft messagebus";
    homepage = "https://github.com/MycroftAI/mycroft-messagebus-client";
    license = licenses.asl20;
    maintainers = teams.mycroft.members;
  };
}
