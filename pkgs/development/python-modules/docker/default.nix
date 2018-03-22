{ stdenv, buildPythonPackage, fetchPypi
, six, requests, websocket_client
, ipaddress, backports_ssl_match_hostname, docker_pycreds
}:
buildPythonPackage rec {
  version = "2.7.0";
  pname = "docker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "144248308e8ea31c4863c6d74e1b55daf97cc190b61d0fe7b7313ab920d6a76c";
  };

  propagatedBuildInputs = [
    six
    requests
    websocket_client
    ipaddress
    backports_ssl_match_hostname
    docker_pycreds
  ];

  # Flake8 version conflict
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An API client for docker written in Python";
    homepage = https://github.com/docker/docker-py;
    license = licenses.asl20;
    maintainers = with maintainers; [
      jgeerds
    ];
  };
}
