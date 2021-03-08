{ lib, stdenv, buildPythonPackage, fetchPypi, pythonOlder
, bcrypt, blinker, flask, flask-compress, flask-cors, mohawk, psycopg2, pyjwt, pymongo, python-dateutil, pytz, pyyaml, requests, requests-hawk, sentry-sdk
}:

buildPythonPackage rec {
  pname = "alerta-server";
  version = "8.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "32a97eee95aea5527f6efa844c18b727fe4a6d61356ea3c0769a29a163ddcb7e";
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
