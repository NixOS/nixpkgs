{ lib
, buildPythonPackage
, fetchPypi
, flask
, python3-openid
, isPy3k
}:

buildPythonPackage rec {
  pname = "flask-openid";
  version = "1.3.0";
  disable = !isPy3k;

  src = fetchPypi {
    pname = "Flask-OpenID";
    inherit version;
    sha256 = "539289ed2d19af61ae38d8fe46aec9e4de2b56f9f8b46da0b98c0d387f1d975a";
  };

  propagatedBuildInputs = [
    flask
    python3-openid
  ];

  # no tests for repo...
  doCheck = false;

  meta = with lib; {
    description = "OpenID support for Flask";
    homepage = "https://pythonhosted.org/Flask-OpenID/";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
