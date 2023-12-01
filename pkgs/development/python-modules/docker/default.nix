{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, packaging
, paramiko
, pytestCheckHook
, requests
, setuptools-scm
, urllib3
, websocket-client
}:

buildPythonPackage rec {
  pname = "docker";
  version = "6.1.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qm0XgwBFul7wFo1eqjTTe+6xE5SMQTr/4dWZH8EfmiA=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    packaging
    requests
    urllib3
    websocket-client
  ];

  passthru.optional-dependencies.ssh = [
    paramiko
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    "tests/unit"
  ];

  # Deselect socket tests on Darwin because it hits the path length limit for a Unix domain socket
  disabledTests = lib.optionals stdenv.isDarwin [
    "api_test" "stream_response" "socket_file"
  ];

  dontUseSetuptoolsCheck = true;

  pythonImportsCheck = [
    "docker"
  ];

  meta = with lib; {
    description = "An API client for docker written in Python";
    homepage = "https://github.com/docker/docker-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
