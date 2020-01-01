{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, pyyaml
, python-dateutil
, requests
, pymongo
, raven
, bcrypt
, flask
, pyjwt
, flask-cors
, psycopg2
, pytz
, flask-compress
, jinja2
, sentry-sdk
}:

buildPythonPackage rec {
  pname = "alerta-server";
  version = "7.4.1";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a6f7740c97f2ae552a4b50bfb709596eabb01bf73715685c9b93ea9fec1821f3";
  };

  propagatedBuildInputs = [
    bcrypt
    flask
    flask-compress
    flask-cors
    jinja2
    psycopg2
    pyjwt
    pymongo
    python-dateutil
    pytz
    pyyaml
    raven
    requests
    sentry-sdk
  ];

  # We can't run the tests from Nix, because they rely on the presence
  # of a working MongoDB server
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/alertad --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://alerta.io;
    description = "Alerta Monitoring System server";
    license = licenses.asl20;
  };
}
