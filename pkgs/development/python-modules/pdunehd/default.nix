{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "pdunehd";
  version = "1.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "valentinalexeev";
    repo = "pdunehd";
    tag = version;
    sha256 = "sha256-8CL7ZQ+tV0CKdqWWiPDbo6Q5d1iIj/vNbYshdjUpYSw=";
  };

  propagatedBuildInputs = [ requests ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pdunehd" ];

  meta = with lib; {
    description = "Python wrapper for Dune HD media player API";
    homepage = "https://github.com/valentinalexeev/pdunehd";
    changelog = "https://github.com/valentinalexeev/pdunehd/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
