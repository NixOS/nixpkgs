{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  websocket-client,
  python-magic,
  cryptography,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "pushbullet-py";
  version = "0.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "917883e1af4a0c979ce46076b391e0243eb8fe0a81c086544bcfa10f53e5ae64";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cryptography
    python-magic
    requests
    websocket-client
  ];

  preCheck = ''
    export PUSHBULLET_API_KEY=""
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests =
    [
      "test_auth_fail"
      "test_auth_success"
      "test_decryption"
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # AttributeError: 'called_once_with' is not a valid assertion. Use a spec for the mock if 'called_once_with' is meant to be an attribute.. Did you mean: 'assert_called_once_with'?
      "test_new_device_ok"
      "test_new_chat_ok"
    ];

  meta = with lib; {
    description = "A simple python client for pushbullet.com";
    homepage = "https://github.com/randomchars/pushbullet.py";
    license = licenses.mit;
  };
}
