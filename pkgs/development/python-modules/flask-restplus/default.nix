{ lib
, buildPythonPackage
, fetchPypi
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
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fad697e1d91dfc13c078abcb86003f438a751c5a4ff41b84c9050199d2eab62";
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
    homepage = https://github.com/noirbizarre/flask-restplus;
    description = "Fast, easy and documented API development with Flask";
    license = lib.licenses.mit;
  };
}
