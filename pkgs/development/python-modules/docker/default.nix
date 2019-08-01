{ stdenv, buildPythonPackage, fetchPypi
, six, requests, websocket_client
, ipaddress, backports_ssl_match_hostname, docker_pycreds
}:
buildPythonPackage rec {
  version = "3.7.2";
  pname = "docker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c456ded5420af5860441219ff8e51cdec531d65f4a9e948ccd4133e063b72f50";
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
    ];
  };
}
