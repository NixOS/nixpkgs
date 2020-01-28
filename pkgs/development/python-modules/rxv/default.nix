{ lib
, buildPythonPackage
, fetchFromGitHub
, defusedxml
, requests
, pytest
, requests-mock
, mock
, pytestcov
, pytest-timeout
, testtools
}:

buildPythonPackage rec {
  pname = "rxv";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "wuub";
    repo = pname;
    # Releases are not tagged
    rev = "9b586203665031f93960543a272bb1a8f541ed37";
    sha256 = "1dw3ayrzknai2279bhkgzcapzw06rhijlny33rymlbp7irp0gvnj";
  };

  propagatedBuildInputs = [ defusedxml requests ];

  checkInputs = [ pytest requests-mock mock pytestcov pytest-timeout testtools ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Automation Library for Yamaha RX-V473, RX-V573, RX-V673, RX-V773 receivers";
    homepage = https://github.com/wuub/rxv;
    license = licenses.mit;
    maintainers = with maintainers; [ flyfloh ];
  };
}

