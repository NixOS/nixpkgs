{ lib, buildPythonPackage, fetchPypi,
  blinker, flask, mock, nose, speaklater
}:

buildPythonPackage rec {
  pname = "Flask-Mail";
  version = "0.9.1";

  meta = {
    description = "Flask-Mail is a Flask extension providing simple email sending capabilities.";
    homepage = "https://pypi.python.org/pypi/Flask-Mail";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hazjc351s3gfbhk975j8k65cg4gf31yq404yfy0gx0bjjdfpr92";
  };

  propagatedBuildInputs = [ blinker flask ];
  buildInputs = [ blinker mock nose speaklater ];

  doCheck = false;
}
