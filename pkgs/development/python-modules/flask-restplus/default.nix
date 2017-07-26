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
}:

buildPythonPackage rec {
  pname = "flask-restplus";
  version = "0.10.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qs9c3fzidd0m3r8rhw0zqrlsaqr2561z45xs6kg19l7c2x6g5qj";
  };

  checkInputs = [ nose blinker tzlocal mock rednose ];
  propagatedBuildInputs = [ flask six jsonschema pytz aniso8601 flask-restful ];

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
