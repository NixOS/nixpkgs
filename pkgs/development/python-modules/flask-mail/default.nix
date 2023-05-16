{ lib, buildPythonPackage, fetchPypi,
  blinker, flask, mock, nose, speaklater
}:

buildPythonPackage rec {
<<<<<<< HEAD
  pname = "flask-mail";
=======
  pname = "Flask-Mail";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  version = "0.9.1";

  meta = {
    description = "Flask-Mail is a Flask extension providing simple email sending capabilities.";
    homepage = "https://pypi.python.org/pypi/Flask-Mail";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
<<<<<<< HEAD
    pname = "Flask-Mail";
    inherit version;
    hash = "sha256-IuXrmpQL9Ae88wQQ7MNwjzxWzESynDThcm/oUAaTX0E=";
=======
    inherit pname version;
    sha256 = "0hazjc351s3gfbhk975j8k65cg4gf31yq404yfy0gx0bjjdfpr92";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ blinker flask ];
  buildInputs = [ blinker mock nose speaklater ];

  doCheck = false;
}
