{ stdenv, buildPythonPackage, fetchPypi, makeWrapper
, python-dateutil, requests, pymongo, raven, bcrypt, flask, pyjwt, flask-cors, psycopg2, pytz, flask-compress, jinja2
}:

buildPythonPackage rec {
  pname = "alerta-server";
  version = "6.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mp97scdz2scdzi9va99hghmjz25zssgwg07i6cldzkc8j71kax5";
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
