{ stdenv, buildPythonPackage, fetchurl
, six, requests2, websocket_client
, ipaddress, backports_ssl_match_hostname, docker_pycreds
}:
buildPythonPackage rec {
  name = "docker-${version}";
  version = "2.0.2";

  src = fetchurl {
    url = "mirror://pypi/d/docker/${name}.tar.gz";
    sha256 = "1m16n2r8is1gxwmyr6163na2jdyzsnhhk2qj12l7rzm1sr9nhx7z";
  };

  propagatedBuildInputs = [
    six
    requests2
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
