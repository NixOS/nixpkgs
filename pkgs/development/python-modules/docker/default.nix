{ stdenv, buildPythonPackage, fetchPypi
, six, requests, websocket_client
, ipaddress, backports_ssl_match_hostname, docker_pycreds
}:
buildPythonPackage rec {
  version = "3.5.1";
  pname = "docker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fbe82af9b94ccced752527c8de07fa20267f9634b48674ba478a0bb4000a0b1e";
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
