{ lib, buildPythonPackage, fetchPypi, flask, pytest }:

buildPythonPackage rec {
<<<<<<< HEAD
  pname = "flask-script";
  version = "2.0.6";

  src = fetchPypi {
    pname = "Flask-Script";
    inherit version;
    hash = "sha256-ZCWWPZEFTPzBhYBxQccxSpxa1GMlkRvSTctIm9AWHGU=";
=======
  pname = "Flask-Script";
  version = "2.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r8w2v89nj6b9p91p495cga5m72a673l2wc0hp0zqk05j4yrc9b4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
