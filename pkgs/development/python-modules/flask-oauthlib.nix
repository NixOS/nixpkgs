{ stdenv, buildPythonPackage, fetchFromGitHub
, flask, oauthlib, requests_oauthlib, flask_sqlalchemy
, mock, nose}:
buildPythonPackage rec {
  pname = "Flask-OAuthlib";
  name = "${pname}-${version}";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "flask-oauthlib";
    rev = "v${version}";
    sha256 = "1vnr2kmbwl6mv2fsv92jjxzfibq2m3pnbcs6ba9k32jr1ci7wfh7";
  };

  buildInputs = [ mock nose ];
  propagatedBuildInputs = [
    flask flask_sqlalchemy oauthlib requests_oauthlib
  ];

  checkPhase = "nosetests -d";
  doCheck = false; # request mocking fails

  meta = with stdenv.lib; {
    description = "OAuthlib implementation for Flask";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
    homepage = https://github.com/lepture/flask-oauthlib;
  };
}
