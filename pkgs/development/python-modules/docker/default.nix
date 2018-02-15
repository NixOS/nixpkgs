{ stdenv, buildPythonPackage, fetchurl
, six, requests, websocket_client
, ipaddress, backports_ssl_match_hostname, docker_pycreds
}:
buildPythonPackage rec {
  version = "3.0.0";
  pname = "docker";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/docker/${name}.tar.gz";
    sha256 = "4a1083656c6ac7615c19094d9b5e052f36e38d0b07e63d7e506c9b5b32c3abe2";
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
