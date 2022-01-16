{ lib
, python-dateutil
, socketio-client
, requests
, websocket-client
, funcsigs
, setuptools
, nose
, coverage
, mock
, jsonschema
, buildPythonPackage
, fetchFromGitHub }:
buildPythonPackage rec {
  pname = "ripe-atlas-cousteau";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = "ripe-atlas-cousteau";
    # 1.4.2 tag is not here...
    rev = if version == "1.4.2" then "${version}" else "v${version}";
    sha256 = "sha256-hEuqun39NLocFIi2lCftRvkEBbLTeST1wcnGg+l2Oc0=";
  };


  postPatch = ''
    # websocket-client is a transitive dependency of socketio-client.
    # <0.99 is not necessary.
    substituteInPlace setup.py \
      --replace "websocket-client<0.99" "websocket-client"
  '';


  propagatedBuildInputs = [
    python-dateutil
    requests
    websocket-client
    socketio-client
  ];

  checkInputs = [
    funcsigs # For Python 3.3, which is supposed to be EOL.
    setuptools
    nose
    coverage
    mock
    jsonschema
  ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A Python client library for RIPE ATLAS API";
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-cousteau";
    license = licenses.gpl3;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
