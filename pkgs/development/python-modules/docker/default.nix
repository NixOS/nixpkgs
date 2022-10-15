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
  version = "6.0.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GeMwRwr0AWfSk7A1JXjB+iLXSzTT7fXU/5DrwgO7svE=";
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

  checkInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    "tests/unit"
  ];

  # Deselect socket tests on Darwin because it hits the path length limit for a Unix domain socket
  disabledTests = lib.optionals stdenv.isDarwin [ "api_test" "stream_response" "socket_file" ];

  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    description = "An API client for docker written in Python";
    homepage = "https://github.com/docker/docker-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
