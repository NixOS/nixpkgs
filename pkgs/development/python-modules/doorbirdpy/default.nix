{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "doorbirdpy";
  version = "2.1.0";

  src = fetchPypi {
    pname = "DoorBirdPy";
    inherit version;
    sha256 = "ed0e94953cdf96111c7f73c5fcf358f65dc0ff5e47f63fc057bf18ca7512e606";
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
