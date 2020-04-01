{ lib, stdenv, buildPythonPackage, fetchPypi, isPy27
, backports_ssl_match_hostname
, mock
, paramiko
, pytest
, pytestCheckHook
, requests
, six
, websocket_client
}:

buildPythonPackage rec {
  pname = "docker";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bkj1xfp6mnvk1i9hl5awsmwi07q6iwwsjznd7kvrx5m19i6dbnx";
  };

  nativeBuildInputs = [
    pytestCheckHook
  ] ++ lib.optional isPy27 mock;

  propagatedBuildInputs = [
    paramiko
    requests
    six
    websocket_client
  ] ++ lib.optional isPy27 backports_ssl_match_hostname;

  pytestFlagsArray = [ "tests/unit" ];
  # Deselect socket tests on Darwin because it hits the path length limit for a Unix domain socket
  disabledTests = lib.optionals stdenv.isDarwin [ "stream_response" "socket_file" ];

  # skip setuptoolsCheckPhase
  doCheck = false;

  meta = with lib; {
    description = "An API client for docker written in Python";
    homepage = "https://github.com/docker/docker-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
