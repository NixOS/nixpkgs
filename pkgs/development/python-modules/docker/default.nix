{ stdenv, buildPythonPackage, fetchPypi
, six, requests, websocket_client
, ipaddress, backports_ssl_match_hostname, docker_pycreds
}:
buildPythonPackage rec {
  version = "3.4.0";
  pname = "docker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9cc39e24905e67ba9e2df14c94488f5cf030fb72ae1c60de505ce5ea90503f7";
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
