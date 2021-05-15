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
, websocket_client
}:

buildPythonPackage rec {
  pname = "docker";
  version = "4.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3393c878f575d3a9ca3b94471a3c89a6d960b35feb92f033c0de36cc9d934db";
  };

  nativeBuildInputs = lib.optional isPy27 mock;

  propagatedBuildInputs = [
    paramiko
    requests
    six
    websocket_client
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
