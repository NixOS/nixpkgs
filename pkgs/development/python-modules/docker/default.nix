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
  version = "6.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3MCIrcLsTnz8WU4nXYvSyXOMVsgI3pdHaTnvZ9ta+MI=";
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
    description = "An API client for docker";
    homepage = "https://github.com/docker/docker-py";
    changelog = "https://github.com/docker/docker-py/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
