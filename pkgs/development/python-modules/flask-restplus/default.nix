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
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p4zz8b5bwbw7w0vhbyihl99d2gw13cb81rxzj4z626a1cnl8vm6";
  };

  nativeCheckInputs = [ nose blinker tzlocal mock rednose ];
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
