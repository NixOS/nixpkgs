{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, pyyaml
, python-dateutil, requests, pymongo, raven, bcrypt, flask, pyjwt, flask-cors, psycopg2, pytz, flask-compress, jinja2
}:

buildPythonPackage rec {
  pname = "alerta-server";
  version = "7.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "507abdb64c8b83c8ff0c21e39b03a21ccd7884ca3ce31afacea2d97e4d39f2e8";
  };

  propagatedBuildInputs = [ python-dateutil requests pymongo raven bcrypt flask pyjwt flask-cors psycopg2 pytz flask-compress jinja2 pyyaml];

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
