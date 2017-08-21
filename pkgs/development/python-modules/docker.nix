{ stdenv, buildPythonPackage, fetchurl
, six, requests, websocket_client
, ipaddress, backports_ssl_match_hostname, docker_pycreds
}:
buildPythonPackage rec {
  version = "2.3.0";
  pname = "docker";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/docker/${name}.tar.gz";
    sha256 = "b0e3f353a3df3eedfbbcaf48235117263479b893edfa0cf6d8d056cca5edde1c";
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
