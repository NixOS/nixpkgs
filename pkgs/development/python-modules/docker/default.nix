{ stdenv, buildPythonPackage, fetchPypi, isPy27
, backports_ssl_match_hostname
, mock
, paramiko
, pytest
, requests
, six
, websocket_client
}:

buildPythonPackage rec {
  version = "4.0.2";
  pname = "docker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r1i46h8x1vfvadayyvmh5hc6mpzgv3vvp6pv4g1wavamya2wnyc";
  };

  propagatedBuildInputs = [
    six
    requests
    websocket_client
    paramiko
  ] ++ stdenv.lib.optional isPy27 backports_ssl_match_hostname;

  checkInputs = [
    mock
    pytest
  ];

  # Other tests touch network
  checkPhase = ''
    ${pytest}/bin/pytest tests/unit/
  '';

  meta = with stdenv.lib; {
    description = "An API client for docker written in Python";
    homepage = https://github.com/docker/docker-py;
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
