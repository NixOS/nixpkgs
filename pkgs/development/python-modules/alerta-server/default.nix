{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, pyyaml
, python-dateutil, requests, pymongo, raven, bcrypt, flask, pyjwt, flask-cors, psycopg2, pytz, flask-compress, jinja2
}:

buildPythonPackage rec {
  pname = "alerta-server";
  version = "7.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a6f7740c97f2ae552a4b50bfb709596eabb01bf73715685c9b93ea9fec1821f3";
  };

  propagatedBuildInputs = [ python-dateutil requests pymongo raven bcrypt flask pyjwt flask-cors psycopg2 pytz flask-compress jinja2 pyyaml];

  doCheck = false; # We can't run the tests from Nix, because they rely on the presence of a working MongoDB server

  postInstall = ''
    wrapProgram $out/bin/alertad --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  disabled = pythonOlder "3.5";

  meta = with stdenv.lib; {
    homepage = https://alerta.io;
    description = "Alerta Monitoring System server";
    license = licenses.asl20;
  };
}
