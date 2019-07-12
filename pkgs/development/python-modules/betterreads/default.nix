{ buildPythonPackage, fetchFromGitHub, lib
, backports-datetime-fromisoformat
, rauth, requests, xmltodict
, pytest
}:

buildPythonPackage rec {
  pname = "betterreads";
  version = "0.4.2";

  # No tests in Pypi distribution
  src = fetchFromGitHub {
    owner = "thejessleigh";
    repo = "betterreads";
    rev = version;
    sha256 = "1z8pzbail4zazw1g07s0lyqp4pa3cma03fl6y7c6734g06fn4b2w";
  };

  propagatedBuildInputs = [
    backports-datetime-fromisoformat
    rauth
    requests
    xmltodict
  ];

  checkInputs = [ pytest ];
  # Exclude network-based tests
  checkPhase = "pytest --deselect tests/integration";

  meta = with lib; {
    description = "A Python interface for the Goodreads API";
    license = licenses.mit;
    homepage = https://github.com/thejessleigh/betterreads;
    maintainers = with maintainers; [ mredaelli ];
  };

}
