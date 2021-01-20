{ lib, stdenv, buildPythonPackage, fetchPypi, pythonOlder
, bcrypt, blinker, flask, flask-compress, flask-cors, mohawk, psycopg2, pyjwt, pymongo, python-dateutil, pytz, pyyaml, requests, requests-hawk, sentry-sdk
}:

buildPythonPackage rec {
  pname = "alerta-server";
  version = "8.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee06d0f828b679402847989de9013a1271db282af377f5dce776347623dde345";
  };

  propagatedBuildInputs = [
    bcrypt
    blinker
    flask
    flask-compress
    flask-cors
    mohawk
    psycopg2
    pyjwt
    pymongo
    python-dateutil
    pytz
    pyyaml
    requests
    requests-hawk
    sentry-sdk
  ];

  doCheck = false; # We can't run the tests from Nix, because they rely on the presence of a working MongoDB server

  postInstall = ''
    wrapProgram $out/bin/alertad --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  disabled = pythonOlder "3.5";

  meta = with lib; {
    homepage = "https://alerta.io";
    description = "Alerta Monitoring System server";
    license = licenses.asl20;
  };
}
