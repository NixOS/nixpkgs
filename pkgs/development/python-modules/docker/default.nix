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
  version = "4.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de5753b7f6486dd541a98393e423e387579b8974a5068748b83f852cc76a89d6";
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
  disabledTests = lib.optionals stdenv.isDarwin [ "stream_response" "socket_file" ];

  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    description = "An API client for docker written in Python";
    homepage = "https://github.com/docker/docker-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
