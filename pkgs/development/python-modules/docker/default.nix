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
  version = "5.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d916a26b62970e7c2f554110ed6af04c7ccff8e9f81ad17d0d40c75637e227fb";
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
