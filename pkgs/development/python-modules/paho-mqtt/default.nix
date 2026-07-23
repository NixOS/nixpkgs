{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  hatchling,
  openssl,
  pytestCheckHook,
  pytest-rerunfailures,
  writableTmpDirAsHomeHook,
}:

let
  testing = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.testing";
    rev = "a4dc694010217b291ee78ee13a6d1db812f9babd";
    hash = "sha256-SQoNdkWMjnasPjpXQF2yV97MUra8gb27pc3rNoA8Rjw=";
  };
in
buildPythonPackage rec {
  pname = "paho-mqtt";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.python";
    rev = "v${version}";
    hash = "sha256-VMq+WTW+njK34QUUTE6fR2j2OmHxVzR0wrC92zYb1rY=";
  };

  patches = [
    (fetchpatch {
      name = "generate-ssl-certs-in-a-test-fixture.patch";
      url = "https://github.com/eclipse-paho/paho.mqtt.python/pull/931.diff";
      hash = "sha256-A7rWwpR4PnCi77F1VqsQKHBxHNrdeHgmVM6BGMeUpjs=";
    })
  ];

  build-system = [
    hatchling
  ];

  nativeCheckInputs = [
    openssl
    pytestCheckHook
    pytest-rerunfailures
    writableTmpDirAsHomeHook
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "paho.mqtt" ];

  preCheck = ''
    ln -s ${testing} paho.mqtt.testing

    # paho.mqtt not in top-level dir to get caught by this
    export PYTHONPATH=".:$PYTHONPATH"
  '';

  pytestFlags = [
    "--reruns=3"
    "--reruns-delay=1"
  ];

  disabledTests = [
    # Fails during teardown
    # RuntimeError: Client 01-zero-length-clientid.py exited with code None, expected 0
    "test_01_zero_length_clientid"
  ];

  disabledTestPaths = [
    # Expired key material
    # https://github.com/eclipse-paho/paho.mqtt.python/pull/854
    "tests/lib/test_08_ssl_connect_alpn.py"
    "tests/lib/test_08_ssl_connect_cert_auth.py"
    "tests/lib/test_08_ssl_connect_cert_auth_pw.py"
    "tests/lib/test_08_ssl_connect_no_auth.py"
  ];

  meta = {
    changelog = "https://github.com/eclipse/paho.mqtt.python/blob/${src.rev}/ChangeLog.txt";
    description = "MQTT version 5.0/3.1.1 client class";
    homepage = "https://eclipse.org/paho";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [
      mog
      dotlambda
    ];
  };
}
