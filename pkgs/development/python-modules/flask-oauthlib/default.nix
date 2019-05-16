{ stdenv, buildPythonPackage, fetchFromGitHub
, flask, oauthlib, requests_oauthlib, flask_sqlalchemy
, mock, nose}:
buildPythonPackage rec {
  pname = "Flask-OAuthlib";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "flask-oauthlib";
    rev = "v${version}";
    sha256 = "1l82niwrpm7411xvwh65bj263si90kcbrbfg5fa52mpixhxcp40f";
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
