{ stdenv, buildPythonPackage, fetchPypi, pythonAtLeast
, flask, blinker, nose, mock, semantic-version }:

buildPythonPackage rec {
  pname = "Flask-Login";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jqb3jfm92yyz4f8n3f92f7y59p8m9j98cyc19wavkjvbgqswcvd";
  };

  checkInputs = [ nose mock semantic-version ];
  propagatedBuildInputs = [ flask blinker ];

  checkPhase = "nosetests -d";

  doCheck = pythonAtLeast "3.3";

  meta = with stdenv.lib; {
    homepage = "https://github.com/maxcountryman/flask-login";
    description = "User session management for Flask";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
