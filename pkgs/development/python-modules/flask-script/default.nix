{ lib, buildPythonPackage, fetchPypi, flask, pytest }:

buildPythonPackage rec {
  pname = "flask-script";
  version = "2.0.6";

  src = fetchPypi {
    pname = "Flask-Script";
    inherit version;
    hash = "sha256-ZCWWPZEFTPzBhYBxQccxSpxa1GMlkRvSTctIm9AWHGU=";
  };

  propagatedBuildInputs = [ flask ];
  nativeCheckInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/smurfix/flask-script";
    description = "Scripting support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
  };
}
