{ lib, buildPythonPackage, fetchPypi, flask, pytest }:

buildPythonPackage rec {
  pname = "Flask-Script";
  version = "2.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zqh2yq8zk7m9b4xw1ryqmrljkdigfb3hk5155a3b5hkfnn6xxyf";
  };

  propagatedBuildInputs = [ flask ];
  checkInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/smurfix/flask-script;
    description = "Scripting support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
  };
}
