{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, bcrypt, blinker, flask, flask-compress, flask-cors, mohawk, psycopg2, pyjwt, pymongo, python-dateutil, pytz, pyyaml, requests, requests-hawk, sentry-sdk
}:

buildPythonPackage rec {
  pname = "alerta-server";
  version = "8.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "894d240c51428225264867a80094b9743d71272635a18ddfefa5832b61fed2c6";
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

  meta = with stdenv.lib; {
    homepage = "https://alerta.io";
    description = "Alerta Monitoring System server";
    license = licenses.asl20;
  };
}
