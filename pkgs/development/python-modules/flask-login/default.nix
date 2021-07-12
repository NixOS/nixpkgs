{ lib, buildPythonPackage, fetchPypi, pythonAtLeast
, flask, blinker, nose, mock, semantic-version }:

buildPythonPackage rec {
  pname = "Flask-Login";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d33aef15b5bcead780acc339464aae8a6e28f13c90d8b1cf9de8b549d1c0b4b";
  };

  checkInputs = [ nose mock semantic-version ];
  propagatedBuildInputs = [ flask blinker ];

  checkPhase = "nosetests -d";

  doCheck = pythonAtLeast "3.3";

  meta = with lib; {
    homepage = "https://github.com/maxcountryman/flask-login";
    description = "User session management for Flask";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
