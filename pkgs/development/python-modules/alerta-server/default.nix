{ stdenv, buildPythonPackage, fetchPypi, makeWrapper
, python-dateutil, requests, pymongo, raven, bcrypt, flask, pyjwt, flask-cors, psycopg2, pytz, flask-compress, jinja2
}:

buildPythonPackage rec {
  pname = "alerta-server";
  version = "6.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ce0ff9bdf1faef2c2bfaef5b213824dc9a307ba1c85f9627dd3f4b88616f4d4";
  };

  buildInputs = [ python-dateutil requests pymongo raven bcrypt flask pyjwt flask-cors psycopg2 pytz flask-compress jinja2 ];

  doCheck = false; # We can't run the tests from Nix, because they rely on the presence of a working MongoDB server

  postInstall = ''
    wrapProgram $out/bin/alertad --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://alerta.io;
    description = "Alerta Monitoring System server";
    license = licenses.asl20;
  };
}
