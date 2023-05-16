{ lib
, buildPythonPackage
, fetchPypi
, flask
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-talisman";
<<<<<<< HEAD
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xfSG9fVEIHKfhLPDhQzWP5bosDOpYpvuZsUk6jY3l/8=";
=======
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IF0958Xs+tZnyEEj9fvlgLH2jNmhsFjXNTzANI4Vsb8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    flask
  ];

  propagatedBuildInputs = [
    six
  ];

  nativeBuildInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "HTTP security headers for Flask";
    homepage = "https://github.com/wntrblm/flask-talisman";
    license = licenses.asl20;
    maintainers = [ lib.maintainers.symphorien ];
  };
}
