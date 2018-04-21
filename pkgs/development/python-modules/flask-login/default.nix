{ stdenv, buildPythonPackage, fetchFromGitHub, pythonAtLeast
, flask, blinker, nose, mock, semantic-version }:

buildPythonPackage rec {
  pname = "Flask-Login";
  name = "${pname}-${version}";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = "flask-login";
    rev = version;
    sha256 = "1rj0qwyxapxnp84fi4lhmvh3d91fdiwz7hibw77x3d5i72knqaa9";
  };

  checkInputs = [ nose mock semantic-version ];
  propagatedBuildInputs = [ flask blinker ];

  checkPhase = "nosetests -d";

  doCheck = pythonAtLeast "3.3";

  meta = with stdenv.lib; {
    homepage = https://github.com/maxcountryman/flask-login;
    description = "User session management for Flask";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
