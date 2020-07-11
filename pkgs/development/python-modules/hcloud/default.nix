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
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xkds49z4hjyvz170913dz6886lhq4hb2n6dqqpv6q5p1znsx2gj";
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