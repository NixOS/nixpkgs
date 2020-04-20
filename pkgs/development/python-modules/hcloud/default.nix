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
}:

buildPythonPackage rec {
  pname = "hcloud";
  version = "1.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0idm73k144lk4aw07r8gwxlb0281j09d6l16a0nrn82r36lwq9fy";
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