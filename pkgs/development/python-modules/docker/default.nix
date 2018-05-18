{ stdenv, buildPythonPackage, fetchPypi
, six, requests, websocket_client
, ipaddress, backports_ssl_match_hostname, docker_pycreds
}:
buildPythonPackage rec {
  version = "3.2.1";
  pname = "docker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d698c3dc4df66c988de5df21a62cdc3450de2fa8523772779e5e23799c41f43";
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
