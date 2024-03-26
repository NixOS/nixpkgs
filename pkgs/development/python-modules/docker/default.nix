{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools
, setuptools-scm

# dependencies
, packaging
, requests
, urllib3

# optional-dependenices
, paramiko
, websocket-client

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "docker";
  version = "7.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Mjc2+5LNlBj8XnEzvJU+EanaBPRIP4KLUn21U/Hn5aM=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    packaging
    requests
    urllib3
  ];

  passthru.optional-dependencies = {
    ssh = [
      paramiko
    ];
    websockets = [
      websocket-client
    ];
  };

  pythonImportsCheck = [
    "docker"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    "tests/unit"
  ];

  # Deselect socket tests on Darwin because it hits the path length limit for a Unix domain socket
  disabledTests = lib.optionals stdenv.isDarwin [
    "api_test"
    "stream_response"
    "socket_file"
  ];

  meta = with lib; {
    changelog = "https://github.com/docker/docker-py/releases/tag/${version}";
    description = "An API client for docker written in Python";
    homepage = "https://github.com/docker/docker-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
