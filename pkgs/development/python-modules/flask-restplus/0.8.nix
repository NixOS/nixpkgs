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
  version = "0.8.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3bb76cc156b9a09da62396d82b29fa31e4f27cccf79528538fe7155cf2785593";
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