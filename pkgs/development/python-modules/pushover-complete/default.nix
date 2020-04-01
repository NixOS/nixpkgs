{ lib
, buildPythonPackage
, fetchPypi
, requests
, six
, tox
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pushover-complete";
  version = "1.1.1";

  src = fetchPypi {
    pname = "pushover_complete";
    inherit version;
    sha256 = "8a8f867e1f27762a28a0832c33c6003ca54ee04c935678d124b4c071f7cf5a1f";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  checkInputs = [ pytest tox ];

  # Fails also on their travis right now:
  # - https://travis-ci.org/scolby33/pushover_complete/builds?utm_medium=notification&utm_source=github_status
  doCheck = pythonOlder "3.7";

  meta = with lib; {
    description = "A Python package for interacting with *all* aspects of the Pushover API";
    homepage = https://github.com/scolby33/pushover_complete;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
