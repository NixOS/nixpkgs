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
    sha256 = "1k20ivs27g2fv4cwr1j9nxc47xd47rlpd08ay8vy9krvv5blbff8";
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
