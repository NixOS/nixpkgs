{ stdenv, buildPythonPackage, fetchFromGitHub, pythonAtLeast
, flask, nose, mock, blinker}:

buildPythonPackage rec {
  pname = "Flask-Login";
  name = "${pname}-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = "flask-login";
    rev = version;
    sha256 = "0sjbmk8m4mmd9g99n6c6lx9nv2jwwqp6qsqhl945w2m0f1sknwdh";
  };

  buildInputs = [ nose mock ];
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
