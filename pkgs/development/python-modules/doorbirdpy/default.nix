{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "doorbirdpy";
  version = "2.2.0";

  src = fetchPypi {
    pname = "DoorBirdPy";
    inherit version;
    sha256 = "sha256-ZGIIko5Ac0Q4Jhz+z7FREJ4MhPF9ADDWgQFRtcZ+dWY=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # no tests on PyPI, no tags on GitLab
  doCheck = false;

  pythonImportsCheck = [ "doorbirdpy" ];

  meta = with lib; {
    description = "Python wrapper for the DoorBird LAN API";
    homepage = "https://gitlab.com/klikini/doorbirdpy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
