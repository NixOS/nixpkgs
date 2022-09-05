{ lib
, python-dateutil
, python-socketio
, requests
, jsonschema
, pythonOlder
, pytestCheckHook
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "ripe-atlas-cousteau";
  version = "1.5.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EHZt9Po/1wDwDacXUCVGcuVSOwcIkPCT2JCKGchu8G4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'python-socketio[client]<5' 'python-socketio[client]<6'
  '';

  propagatedBuildInputs = [
    python-dateutil
    requests
    python-socketio
  ];

  checkInputs = [
    pytestCheckHook
    jsonschema
  ];

  pythonImportsCheck = [
    "ripe.atlas.cousteau"
  ];

  meta = with lib; {
    description = "Python client library for RIPE ATLAS API";
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-cousteau";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
