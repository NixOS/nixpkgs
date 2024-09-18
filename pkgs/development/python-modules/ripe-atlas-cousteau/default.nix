{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  pytestCheckHook,
  python-dateutil,
  python-socketio,
  pythonOlder,
  requests,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "ripe-atlas-cousteau";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-z8ZXOiCVYughrbmXfnwtks7NPmYpII2BA0+8mr1cdSQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "websocket-client~=1.3.1" "websocket-client"
  '';

  propagatedBuildInputs = [
    python-dateutil
    requests
    python-socketio
    websocket-client
  ] ++ python-socketio.optional-dependencies.client;

  nativeCheckInputs = [
    pytestCheckHook
    jsonschema
  ];

  pythonImportsCheck = [ "ripe.atlas.cousteau" ];

  meta = with lib; {
    description = "Python client library for RIPE ATLAS API";
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-cousteau";
    changelog = "https://github.com/RIPE-NCC/ripe-atlas-cousteau/blob/v${version}/CHANGES.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
