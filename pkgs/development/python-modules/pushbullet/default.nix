{ lib
, buildPythonPackage
, fetchPypi
, requests
, websocket_client
, python_magic
, cryptography
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pushbullet.py";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "917883e1af4a0c979ce46076b391e0243eb8fe0a81c086544bcfa10f53e5ae64";
  };

  propagatedBuildInputs = [ cryptography requests websocket_client python_magic ];

  preCheck = ''
    export PUSHBULLET_API_KEY=""
  '';
  checkInputs = [ pytestCheckHook ];
  disabledTests = [
    "test_auth_fail"
    "test_auth_success"
    "test_decryption"
  ];

  meta = with lib; {
    description = "A simple python client for pushbullet.com";
    homepage = "https://github.com/randomchars/pushbullet.py";
    license = licenses.mit;
  };
}
