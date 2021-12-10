{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, blinker
, tzlocal
, mock
, rednose
, flask
, six
, jsonschema
, pytz
, aniso8601
, flask-restful
, isPy27
, enum34
}:

buildPythonPackage rec {
  pname = "flask-restplus";
  version = "0.13.0";

  src = fetchFromGitHub {
     owner = "noirbizarre";
     repo = "flask-restplus";
     rev = "0.13.0";
     sha256 = "0p49m0z7nbq5wx8znhafmwdrqp606p049hczi6zkwbjwhb5rkqp9";
  };

  checkInputs = [ nose blinker tzlocal mock rednose ];
  propagatedBuildInputs = [ flask six jsonschema pytz aniso8601 flask-restful ]
   ++ lib.optional isPy27 enum34;

  # RuntimeError: Working outside of application context.
  doCheck = false;

  checkPhase = ''
    nosetests
  '';

  meta = {
    homepage = "https://github.com/noirbizarre/flask-restplus";
    description = "Fast, easy and documented API development with Flask";
    license = lib.licenses.mit;
  };
}
