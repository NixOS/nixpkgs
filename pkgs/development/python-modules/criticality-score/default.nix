{ lib, buildPythonPackage, fetchPypi, PyGithub, python-gitlab }:

buildPythonPackage rec {
  pname = "criticality_score";
  version = "1.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i811a27i87z3j1rw0dwrnw8v0ckbd918ms6shjawhs4cnb1c6x8";
  };

  propagatedBuildInputs = [ PyGithub python-gitlab ];

  doCheck = false;

  pythonImportsCheck = [ "criticality_score" ];

  meta = with lib; {
    description = "Python tool for computing the Open Source Project Criticality Score.";
    homepage = "https://github.com/ossf/criticality_score";
    license = licenses.asl20;
    maintainers = with maintainers; [ wamserma ];
  };
}
