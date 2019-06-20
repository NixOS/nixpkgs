{ stdenv, buildPythonPackage, fetchPypi, isPy27
, six, requests, websocket_client, mock, pytest
, paramiko, backports_ssl_match_hostname
}:

buildPythonPackage rec {
  version = "4.0.1";
  pname = "docker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1284sqy3r6nxyz43vrpzqf25hsidpr0v4cgnbvavg2dl47bkf77n";
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
