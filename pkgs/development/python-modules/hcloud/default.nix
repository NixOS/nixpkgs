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
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fka4m3kbz52pksrjw3v42k611x5kl06dxrc7p5rb64jg6gayjfl";
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
