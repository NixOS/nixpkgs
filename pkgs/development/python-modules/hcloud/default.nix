{ lib
, buildPythonPackage
, fetchFromGitHub
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

  src = fetchFromGitHub {
     owner = "hetznercloud";
     repo = "hcloud-python";
     rev = "v1.16.0";
     sha256 = "12wx796ag02z8lpjkcsy6jqk3faji9pfgxhkmxgcg09l4dh9pi8d";
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
