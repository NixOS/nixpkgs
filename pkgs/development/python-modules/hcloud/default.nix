{ lib
, buildPythonPackage
, fetchPypi
, future
, requests
, python-dateutil
, flake8
, isort
, mock
, pytest
, isPy27
}:

buildPythonPackage rec {
  pname = "hcloud";
  version = "1.16.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8b94557d93bcfe437f20a8176693ea4f54358b74986cc19d94ebc23f48e40cc";
  };

  propagatedBuildInputs = [ future requests python-dateutil ];

  checkInputs = [ flake8 isort mock pytest ];

  # Skip integration tests since they require a separate external fake API endpoint.
  checkPhase = ''
    pytest --ignore=tests/integration
  '';

  meta = with lib; {
    description = "Official Hetzner Cloud python library";
    homepage = "https://github.com/hetznercloud/hcloud-python";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ liff ];
  };
}
