{ lib, buildPythonPackage, fetchPypi, six, requests, websocket_client, docker_pycreds }:

buildPythonPackage rec {
  version = "1.10.6";
  pname = "docker-py";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05f49f6hnl7npmi7kigg0ibqk8s3fhzx1ivvz1kqvlv4ay3paajc";
  };

  # The tests access the network.
  doCheck = false;

  propagatedBuildInputs = [
    six
    requests
    websocket_client
    docker_pycreds
  ];

  meta = {
    description = "Python library for the Docker Remote API";
    homepage = https://github.com/docker/docker-py/;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.pmiddend ];
  };
}
