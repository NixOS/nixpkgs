{ stdenv, buildPythonPackage, fetchPypi, pythonAtLeast
, flask, blinker, nose, mock, semantic-version }:

buildPythonPackage rec {
  pname = "Flask-Login";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v2j8zd558xfmgn3rfbw0xz4vizjcnk8kqw52q4f4d9ygfnc25f8";
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
