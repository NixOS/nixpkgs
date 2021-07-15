{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, backports_ssl_match_hostname
, mock
, paramiko
, pytestCheckHook
, requests
, six
, websocket-client
}:

buildPythonPackage rec {
  pname = "docker";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PovEdTTgypMx1ywy8ogbsTuT3tC83qs8gz+3z2HAqaU=";
  };

  nativeBuildInputs = lib.optional isPy27 mock;

  propagatedBuildInputs = [
    paramiko
    requests
    six
    websocket-client
  ] ++ lib.optional isPy27 backports_ssl_match_hostname;

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit" ];

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
