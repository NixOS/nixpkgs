{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "requests-futures";
  version = "0.9.9-27-gf126048";
  disabled = pythonOlder "3.3";

  src = fetchFromGitHub {
    owner = "ross";
    repo = "requests-futures";
    rev = "f12604869b80c730192a84403f8a9b513c3f2520";
    sha256 = "0a2n4gxpv7wlp7wxjppnigbwvc36zjam97xdzk1g8xg43jb6pjhd";
  };

  propagatedBuildInputs = [ requests ];

  # tests try to access network
  doCheck = false;

  pythonImportsCheck = [ "requests_futures" ];

  meta = with lib; {
    description = "Asynchronous Python HTTP Requests for Humans using Futures";
    homepage = "https://github.com/ross/requests-futures";
    license = licenses.asl20;
    maintainers = with maintainers; [ evils ];
  };
}
