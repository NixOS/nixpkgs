{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, six
}:

buildPythonPackage rec {
  pname = "f5-icontrol-rest";
  version = "1.3.16";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "F5Networks";
    repo = "f5-icontrol-rest-python";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-asAFIRoc2zll8a8gMMt4ZRQILhMAes8wf3PGwG5wF9c=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  # needs to be updated to newer pytest version and requires physical device
  doCheck = false;

  pytestFlags = [
    "icontrol/test"
  ];

  pythonImportsCheck = [ "icontrol" ];

  meta = with lib; {
    description = "F5 BIG-IP iControl REST API client";
    homepage = "https://github.com/F5Networks/f5-icontrol-rest-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
