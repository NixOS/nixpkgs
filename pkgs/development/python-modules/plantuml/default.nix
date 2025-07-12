{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  # Runtime dependencies
  httplib2,
  six,
}:

buildPythonPackage {
  pname = "plantuml";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dougn";
    repo = "python-plantuml";
    rev = "93e1aac25b17d896b0d05d0a1aa352c7bd11dd31";
    hash = "sha256-aPXPqoKlu8VLi0Jn84brG7v3qM9L18Ut4sabYYGb3qQ=";
  };

  propagatedBuildInputs = [
    httplib2
    six
  ];

  # Project does not contain a test suite
  doCheck = false;

  pythonImportsCheck = [ "plantuml" ];

  meta = with lib; {
    description = "Python interface to a plantuml web service instead of having to run java locally";
    homepage = "https://github.com/dougn/python-plantuml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nikstur ];
  };
}
