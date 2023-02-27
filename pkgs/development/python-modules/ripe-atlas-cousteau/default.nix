{ lib
, buildPythonPackage
, fetchFromGitHub
, jsonschema
, pytestCheckHook
, python-dateutil
, python-socketio
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "ripe-atlas-cousteau";
  version = "1.5.1";
  format = "setuptools";


  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EHZt9Po/1wDwDacXUCVGcuVSOwcIkPCT2JCKGchu8G4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'python-socketio[client]<5' 'python-socketio[client]<6'
  '';

  propagatedBuildInputs = [
    python-dateutil
    requests
    python-socketio
  ] ++ python-socketio.optional-dependencies.client;

  nativeCheckInputs = [
    pytestCheckHook
    jsonschema
  ];

  pythonImportsCheck = [
    "ripe.atlas.cousteau"
  ];

  meta = with lib; {
    description = "Python client library for RIPE ATLAS API";
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-cousteau";
    changelog = "https://github.com/RIPE-NCC/ripe-atlas-cousteau/blob/v${version}/CHANGES.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
